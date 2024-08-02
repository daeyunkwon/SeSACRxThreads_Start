//
//  ViewController.swift
//  SeSACRxThreads_Start
//
//  Created by 권대윤 on 8/1/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit


class PasswordViewController: BaseViewController {

    //MARK: - Properties
    
    let disposeBag = DisposeBag()
    
    //MARK: - UI Components
    
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요.")
    
    let nextButton = PointButton(title: "다음")
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    let validText = Observable.just("8자 이상 입력해주세요!")
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Configurations
    
    override func bind() {
        
        validText
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty
            .map { $0.count >= 8 }
            .bind(with: self) { owner, value in
                owner.descriptionLabel.isHidden = value
                owner.nextButton.isEnabled = value
                
                if value {
                    owner.nextButton.backgroundColor = UIColor.systemBlue
                } else {
                    owner.nextButton.backgroundColor = UIColor.systemGray2
                }
                
            }
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind { _ in
                print("버튼 클릭됨")
            }
            .disposed(by: disposeBag)
    }
    
    override func configureLayout() {
        view.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        
        view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(20)
        }
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
    }

}

