//
//  BirthdayViewModel.swift
//  SeSACRxThreads_Start
//
//  Created by 권대윤 on 8/3/24.
//

import Foundation

import RxSwift
import RxCocoa

class BirthdayViewModel {
    
    //MARK: - Properties
    
    let disposeBag = DisposeBag()
    
    private var year = PublishRelay<Int>()
    private var month = PublishRelay<Int>()
    private var day = PublishRelay<Int>()
    
    private var validationAge = PublishSubject<Int>()
     
    //MARK: - Inputs
    
    var calculationAge = PublishSubject<Date>()
    
    //MARK: - Outputs
    
    private(set) var today = PublishSubject<Date>()
    
    private(set) var yearText = PublishRelay<String>()
    private(set) var monthText = PublishRelay<String>()
    private(set) var dayText = PublishRelay<String>()
    
    private(set) var isValidAge = PublishRelay<Bool>()
    
    //MARK: - Init
    
    init() {
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
        
        Observable.just(Date())
            .bind(with: self) { owner, value in
                owner.today.onNext(value)
                
                let dateComponent = Calendar.current.dateComponents([.year, .month, .day], from: value)
                
                owner.year.accept(dateComponent.year ?? 0)
                owner.month.accept(dateComponent.month ?? 0)
                owner.day.accept(dateComponent.day ?? 0)
            }
            .disposed(by: disposeBag)
        
        validationAge
            .map { $0 >= 17 }
            .bind(to: isValidAge)
            .disposed(by: disposeBag)
        
        
        calculationAge
            .map { Calendar.current.dateComponents([.year, .month, .day], from: $0) }
            .bind(with: self) { owner, value in
                owner.year.accept(value.year ?? 0)
                owner.month.accept(value.month ?? 0)
                owner.day.accept(value.day ?? 0)
                
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
                
                owner.validationAge.onNext(age)
            }
            .disposed(by: disposeBag)
    }
    
}
