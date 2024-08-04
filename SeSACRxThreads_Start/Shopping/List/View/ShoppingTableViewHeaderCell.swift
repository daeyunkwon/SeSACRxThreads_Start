//
//  ShoppingTableViewHeaderCell.swift
//  SeSACRxThreads_Start
//
//  Created by 권대윤 on 8/3/24.
//

import UIKit

import RxCocoa
import SnapKit

final class ShoppingTableViewHeaderCell: UITableViewHeaderFooterView {
    
    //MARK: - Properties
    
    weak var delegate: ShoppingTableViewHeaderCellDelegate?
    
    //MARK: - UI Components
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 10
        return view
    }()
    
    let titleTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "무엇을 구매하실 건가요?"
        tf.borderStyle = .none
        tf.textColor = .black
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        return tf
    }()
    
    private lazy var addButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = .systemGray4
        btn.setTitle("추가", for: .normal)
        btn.tintColor = .label
        btn.layer.cornerRadius = 10
        btn.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    //MARK: - Init
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        containerView.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.width.equalTo(64)
            make.height.equalTo(35)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(8)
        }
        
        containerView.addSubview(titleTextField)
        titleTextField.snp.makeConstraints { make in
            make.height.equalTo(34)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalTo(addButton.snp.leading).offset(-5)
        }
    }
    
    //MARK: - Actions
    
    @objc private func addButtonTapped() {
        self.delegate?.addButtonTapped(sender: self)
    }
    
}
