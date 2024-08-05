//
//  BirthdayViewModel.swift
//  SeSACRxThreads_Start
//
//  Created by 권대윤 on 8/3/24.
//

import Foundation

import RxSwift
import RxCocoa

final class BirthdayViewModel {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
     
    //MARK: - Inputs
    
    struct Input {
        let pickerDate: ControlProperty<Date>
        let nextButtonTap: ControlEvent<Void>
    }
    
    //MARK: - Outputs
    
    struct Output {
        let setupToday: Observable<Date>
        let yearText: BehaviorRelay<String>
        let monthText: BehaviorRelay<String>
        let dayText: BehaviorRelay<String>
        let validationAgeStatus: BehaviorRelay<Bool>
        let nextButtonTap: ControlEvent<Void>
    }
    
    //MARK: - Methods
    
    func transform(input: Input) -> Output {
        
        let setupToday: Observable<Date> = Observable.just(Date())
        let yearText = BehaviorRelay<String>(value: "")
        let monthText = BehaviorRelay<String>(value: "")
        let dayText = BehaviorRelay<String>(value: "")
        let validationAgeStatus = BehaviorRelay<Bool>(value: false)
        
        let year = PublishRelay<Int>()
        let month = PublishRelay<Int>()
        let day = PublishRelay<Int>()
        
        let validationAge = PublishSubject<Int>()
        let valid = PublishSubject<Date>()
        
        year
            .map { "\($0)년" }
            .bind(to: yearText)
            .disposed(by: disposeBag)
        
        month
            .map { "\($0)월" }
            .bind(to: monthText)
            .disposed(by: disposeBag)
        
        day
            .map { "\($0)일" }
            .bind(to: dayText)
            .disposed(by: disposeBag)
        
        validationAge
            .map { $0 >= 17 }
            .bind { value in
                validationAgeStatus.accept(value)
            }
            .disposed(by: disposeBag)
        
        valid
            .map { Calendar.current.dateComponents([.year, .month, .day], from: $0) }
            .bind{ value in
                year.accept(value.year ?? 0)
                month.accept(value.month ?? 0)
                day.accept(value.day ?? 0)
                
                //만나이 계산법: 현재 연도에서 출생 연도를 뺀 다음, 생일이 지났으면 그대로, 지나지 않았으면 1년을 더 빼기
                let todayComponent = Calendar.current.dateComponents([.year, .month, .day], from: Date())
                
                var age = (todayComponent.year ?? 0) - (value.year ?? 0)
                
                if value.month ?? 0 < todayComponent.month ?? 0 {
                    age -= 1
                } else if value.month ?? 0 == todayComponent.month ?? 0 {
                    if value.day ?? 0 < todayComponent.day ?? 0 {
                        age -= 1
                    }
                }
                
                validationAge.onNext(age)
            }
            .disposed(by: disposeBag)
        
        setupToday
            .bind { value in
                valid.onNext(value)
            }
            .disposed(by: disposeBag)
        
        input.pickerDate
            .bind { value in
                valid.onNext(value)
            }
            .disposed(by: disposeBag)
        
        
        return Output(setupToday: setupToday, yearText: yearText, monthText: monthText, dayText: dayText, validationAgeStatus: validationAgeStatus, nextButtonTap: input.nextButtonTap)
    }
    
}
