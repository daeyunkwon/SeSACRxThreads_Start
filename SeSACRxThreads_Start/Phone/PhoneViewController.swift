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
    
    let viewModel = PhoneViewModel()
    
    //MARK: - UI Components
    
    let phoneTextField = SignTextField(placeholderText: "연락처를 입력해주세요")
    
    let nextButton = PointButton(title: "다음")
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Configurations
    
    override func bind() {
        phoneTextField.rx.text.orEmpty
            .filter { $0.isEmpty }
            .bind(with: self, onNext: { owner, _ in
                owner.descriptionLabel.isHidden = true
            })
            .disposed(by: disposeBag)
        
        viewModel.phoneTextFieldInitialValue
            .bind(to: phoneTextField.rx.text.orEmpty)
            .disposed(by: disposeBag)
        
        viewModel.validationMessage
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.isValid
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
            .bind(to: viewModel.validationTextCount)
            .disposed(by: disposeBag)
        
        phoneTextField.rx.text.orEmpty
            .bind(to: viewModel.validationTextNumberAndHyphen)
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
