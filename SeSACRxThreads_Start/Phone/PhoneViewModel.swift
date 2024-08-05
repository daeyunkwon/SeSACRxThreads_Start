//
//  PhoneViewModel.swift
//  SeSACRxThreads_Start
//
//  Created by 권대윤 on 8/3/24.
//

import Foundation

import RxSwift
import RxCocoa

final class PhoneViewModel {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    //MARK: - Inputs
    
    struct Input {
        let phoneNumber: ControlProperty<String>
        let nextButtonTap: ControlEvent<Void>
    }
    
    //MARK: - Outputs
    
    struct Output {
        let setupPhoneTextFieldAndNextButton: Observable<(String, Bool)>
        let phoneNumberValidationStatus: Observable<Bool>
        let validationMessage: PublishSubject<String>
        let nextButtonTap: ControlEvent<Void>
        let phoneTextEmpty: Observable<Bool>
    }
    
    //MARK: - Methods
    
    func transform(input: Input) -> Output {
        let phoneTextFieldInitialValue = Observable.just("010")
        let nextButtonInitalValue = Observable.just(false)
        let setup = Observable.combineLatest(phoneTextFieldInitialValue, nextButtonInitalValue)
        let validationMessage = PublishSubject<String>()
        let numberValidStatus = BehaviorSubject<Bool>(value: false)
        let countValidStatus = PublishSubject<Bool>()
        let phoneTextEmpty = BehaviorSubject<Bool>(value: false)
        
        let phoneNumberValidationStatus = Observable.combineLatest(numberValidStatus, countValidStatus) { value1, value2 in
            return value1 && value2
        }
        
        input.phoneNumber
            .map { $0.isEmpty }
            .bind { value in
                phoneTextEmpty.onNext(value)
            }
            .disposed(by: disposeBag)
        
        input.phoneNumber
            .filter { !$0.isEmpty }
            .map { $0.count >= 10 }
            .bind { value in
                countValidStatus.onNext(value)
                
                if !value {
                    validationMessage.onNext("10자 이상 입력해주세요!")
                }
            }
            .disposed(by: disposeBag)
        
        input.phoneNumber
            .filter { !$0.isEmpty } // 빈 문자열을 필터링
            .bind { value in
                if Int(value) != nil {
                    numberValidStatus.onNext(true)
                    
                } else {
                    numberValidStatus.onNext(false)
                    
                    if value.contains("-") {
                        validationMessage.onNext("'-'를 제외한 숫자만 입력해주세요!")
                    } else {
                        validationMessage.onNext("숫자만 입력해주세요!")
                    }
                }
            }
            .disposed(by: disposeBag)
        
        
        return Output(setupPhoneTextFieldAndNextButton: setup, phoneNumberValidationStatus: phoneNumberValidationStatus, validationMessage: validationMessage, nextButtonTap: input.nextButtonTap, phoneTextEmpty: phoneTextEmpty)
    }
    
}
