//
//  PasswordViewModel.swift
//  SeSACRxThreads_Start
//
//  Created by 권대윤 on 8/2/24.
//

import Foundation

import RxSwift

class PasswordViewModel {
    
    //MARK: - Inputs
    
    let disposeBag = DisposeBag()
    
    var validPasswordText = PublishSubject<String>()
    
    //MARK: - Outputs
    
    private(set) lazy var viewDidLoad = Observable.combineLatest(self.initialEnabled, self.initialHidden)
    private(set) var initialEnabled = Observable.just(false)
    private(set) var initialHidden = Observable.just(true)
    
    private(set) var validationMessage = Observable.just("8자 이상 입력해주세요!")
    
    private(set) var isPasswordValid = PublishSubject<Bool>()
    
    //MARK: - Init
    
    init() {
        validPasswordText
            .map { $0.count >= 8 }
            .bind(to: isPasswordValid)
            .disposed(by: disposeBag)
    }
}
