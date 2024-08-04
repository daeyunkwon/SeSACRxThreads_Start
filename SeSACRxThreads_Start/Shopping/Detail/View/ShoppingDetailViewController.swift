//
//  ShoppingDetailViewController.swift
//  SeSACRxThreads_Start
//
//  Created by 권대윤 on 8/4/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class ShoppingDetailViewController: BaseViewController {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    let viewModel = ShoppingDetailViewModel()
    
    //MARK: - UI Components
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let inputTextView: UITextView = {
        let tv = UITextView()
        tv.isEditable = true
        tv.backgroundColor = .clear
        tv.font = .systemFont(ofSize: 15)
        return tv
    }()
    
    private let saveBarButton = UIBarButtonItem(title: "저장", style: .done, target: nil, action: nil)
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Configurations
    
    override func bind() {
        
        viewModel.shoppingTitleText
            .bind(to: inputTextView.rx.text)
            .disposed(by: disposeBag)
        
        inputTextView.rx.text.orEmpty
            .map { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
            .bind(to: saveBarButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        saveBarButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.viewModel.saveNewTitleText.onNext(owner.inputTextView.text)
                
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    override func setupNavi() {
        navigationItem.title = "수정하기"
        navigationItem.rightBarButtonItem = self.saveBarButton
    }
    
    override func configureLayout() {
        view.addSubview(backView)
        backView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(UIScreen.main.bounds.size.width * 1.5)
        }
        
        backView.addSubview(inputTextView)
        inputTextView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
    }
    
}
