//
//  PhoneViewModel.swift
//  SeSACRxThreads_Start
//
//  Created by 권대윤 on 8/3/24.
//

import Foundation

import RxSwift

class PhoneViewModel {
    
    //MARK: - Properties
    
    let disposeBag = DisposeBag()
    
    //MARK: - Inputs
    
    var validationTextCount = PublishSubject<String>()
    
    var validationTextNumberAndHyphen = PublishSubject<String>()
    
    //MARK: - Outputs
    
    private(set) var phoneTextFieldInitialValue = Observable.just("010")
    
    private(set) var isNumberValid = PublishSubject<Bool>()
    
    private(set) var isCountValid = PublishSubject<Bool>()
    
    private(set) var validationMessage = PublishSubject<String>()
    
    private(set) var isValid = PublishSubject<Bool>()
    
    //MARK: - Init
    
    init() {
        validationTextCount
            .filter { !$0.isEmpty }
            .map { $0.count >= 10 }
            .bind(with: self) { owner, value in
                owner.isCountValid.onNext(value)
                
                if !value {
                    owner.validationMessage.onNext("10자 이상 입력해주세요!")
                }
            }
            .disposed(by: disposeBag)
        
        validationTextNumberAndHyphen
            .filter { !$0.isEmpty } // 빈 문자열을 필터링
            .bind(with: self) { owner, value in
                if Int(value) != nil {
                    owner.isNumberValid.onNext(true)
                } else {
                    owner.isNumberValid.onNext(false)
                    
                    if value.contains("-") {
                        owner.validationMessage.onNext("'-'를 제외한 숫자만 입력해주세요!")
                    } else {
                        owner.validationMessage.onNext("숫자만 입력해주세요!")
                    }
                }
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(isNumberValid ,isCountValid) { numberValid, countValid in
            return numberValid && countValid
        }
        .bind(to: isValid)
        .disposed(by: disposeBag)
        
    }
    
}
