//
//  PhoneViewController.swift
//  SeSACRxThreads_Start
//
//  Created by 권대윤 on 8/2/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class PhoneViewController: BaseViewController {
   
    //MARK: - Properties
    
    let disposeBag = DisposeBag()
    
    //MARK: - UI Components
    
    let phoneTextField = SignTextField(placeholderText: "연락처를 입력해주세요")
    
    let nextButton = PointButton(title: "다음")
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    let validationMessage = PublishSubject<String>()
    let isValid = PublishSubject<Bool>()
    
    let isNumberValid = PublishSubject<Bool>()
    let isCountValid = PublishSubject<Bool>()
    
    let phoneTextFieldInitialValue = Observable.just("010")
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Configurations
    
    override func bind() {
        let debug = Observable.of("test").debug("username")
        
        phoneTextFieldInitialValue
            .bind(to: phoneTextField.rx.text.orEmpty)
            .disposed(by: disposeBag)
        
        validationMessage
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(isNumberValid ,isCountValid) { numberValid, countValid in
            return numberValid && countValid
        }
        .bind(to: isValid)
        .disposed(by: disposeBag)
        
        isValid
            .bind(with: self) { owner, value in
                owner.descriptionLabel.isHidden = value
                owner.nextButton.isEnabled = value
                
                if value {
                    owner.nextButton.backgroundColor = .systemBlue
                } else {
                    owner.nextButton.backgroundColor = .systemGray2
                }
            }
            .disposed(by: disposeBag)
            
        phoneTextField.rx.text.orEmpty
            .map { $0.count >= 10 }
            .bind(with: self) { owner, value in
                owner.isCountValid.onNext(value)
                
                if !value {
                    owner.validationMessage.onNext("10자 이상 입력해주세요!")
                }
            }
            .disposed(by: disposeBag)
        
        phoneTextField.rx.text.orEmpty
            .filter { !$0.isEmpty } // 빈 문자열을 필터링
            .map {
                return Int($0) != nil ? true : false
            }
            .bind(with: self) { owner, value in
                owner.isNumberValid.onNext(value)
                
                if !value {
                    owner.validationMessage.onNext("숫자만 입력해주세요!")
                }
            }
            .disposed(by: disposeBag)
        
        phoneTextField.rx.text.orEmpty
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
        
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.showCompletionAlert()
            }
            .disposed(by: disposeBag)
    }

    override func configureLayout() {
        view.addSubview(phoneTextField)
        phoneTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneTextField.snp.bottom)
            make.horizontalEdges.equalTo(phoneTextField)
        }
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(phoneTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
