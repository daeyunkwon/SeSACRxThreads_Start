//
//  PasswordViewModel.swift
//  SeSACRxThreads_Start
//
//  Created by 권대윤 on 8/2/24.
//

import Foundation

import RxSwift
import RxCocoa

final class PasswordViewModel {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    //MARK: - Inputs
    
    struct Input {
        let nextButtonTap: ControlEvent<Void>
        let password: ControlProperty<String>
    }
    
    //MARK: - Outputs
    
    struct Output {
        let nextButtonTap: ControlEvent<Void>
        let setupViewDidLoad: Observable<(Bool, Bool)>
        let validationMessage: Observable<String>
        let passwordValidationStatus: SharedSequence<DriverSharingStrategy, Bool>
    }
    
    //MARK: - Methods
    
    func transform(input: Input) -> Output {
        let nextButtonTap = input.nextButtonTap
        
        let setupViewDidLoad = Observable.combineLatest(Observable.just(false), Observable.just(true))
        
        let validationMessage = Observable.just("8자 이상 입력해주세요!")
        
        let passwordValidationStatus = input.password
            .filter { !$0.isEmpty }
            .map { $0.count >= 8 }
            .asDriver(onErrorJustReturn: false)
        
        
        return Output(nextButtonTap: nextButtonTap, setupViewDidLoad: setupViewDidLoad, validationMessage: validationMessage, passwordValidationStatus: passwordValidationStatus)
    }
}
