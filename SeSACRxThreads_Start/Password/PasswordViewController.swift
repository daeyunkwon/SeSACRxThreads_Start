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
    
    let viewModel = PasswordViewModel()
    
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
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Configurations
    
    deinit {
        print("PasswordVC deinit")
    }
    
    override func bind() {
        let input = PasswordViewModel.Input(nextButtonTap: nextButton.rx.tap, password: passwordTextField.rx.text.orEmpty)
        let output = viewModel.transform(input: input)
        
        output.setupViewDidLoad
            .bind(onNext: { [weak self] enabledValue, hiddenValue in
                self?.nextButton.isEnabled = enabledValue
                self?.nextButton.backgroundColor = .systemGray2
                self?.descriptionLabel.isHidden = hiddenValue
            })
            .disposed(by: disposeBag)
        
        output.validationMessage
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.passwordValidationStatus
            .drive(nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.passwordValidationStatus
            .drive(descriptionLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.passwordValidationStatus
            .drive(with: self) { owner, value in
                if value {
                    owner.nextButton.backgroundColor = UIColor.systemBlue
                } else {
                    owner.nextButton.backgroundColor = UIColor.systemGray2
                }
            }
            .disposed(by: disposeBag)
        
        output.nextButtonTap
            .bind(with: self) { owner, _ in
                owner.showCompletionAlert()
//                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
//                let sceneDelegate = windowScene?.delegate as? SceneDelegate
//                
//                let navigationController = UINavigationController(rootViewController: BirthdayViewController())
//                
//                sceneDelegate?.window?.rootViewController = navigationController
//                sceneDelegate?.window?.makeKeyAndVisible()
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

