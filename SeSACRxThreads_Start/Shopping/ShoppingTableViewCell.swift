//
//  ShoppingTableViewCell.swift
//  SeSACRxThreads_Start
//
//  Created by 권대윤 on 8/3/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class ShoppingTableViewCell: UITableViewCell {
    
    //MARK: - Properties

    var disposeBag = DisposeBag()
    
    weak var delegate: ShoppingTableViewCellDelegate?
    
    var shopping: Shopping?
    
    var done = false {
        didSet {
            self.updateAppearanceDoneButton()
        }
    }
    
    var favorite = false {
        didSet {
            self.updateAppearanceFavoriteButton()
        }
    }
    
    //MARK: - UI Components
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.tintColor = .label
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    lazy var doneButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.tintColor = .label
        btn.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        btn.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var favoriteButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.tintColor = .label
        btn.setImage(UIImage(systemName: "star"), for: .normal)
        btn.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    //MARK: - Life Cycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //self.disposeBag = DisposeBag() //필요없을 듯
    }
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLayout()
        contentView.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        contentView.addSubview(backView)
        backView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(2)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        backView.addSubview(doneButton)
        doneButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
            make.width.equalTo(49)
            make.height.equalTo(35)
        }
        
        backView.addSubview(favoriteButton)
        favoriteButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
            make.width.equalTo(49)
            make.height.equalTo(35)
        }
        
        backView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(20)
            make.leading.equalTo(doneButton.snp.trailing).offset(10)
            make.trailing.equalTo(favoriteButton.snp.leading).offset(-10)
        }
    }
    
    //MARK: - Actions
    
    @objc private func doneButtonTapped() {
        self.delegate?.doneButtonTapped(sender: self)
    }
    
    @objc private func favoriteButtonTapped() {
        self.delegate?.favoriteButtonTapped(sender: self)
    }
    
    //MARK: - Methods
    
    private func updateAppearanceDoneButton() {
        if self.done {
            doneButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
        } else {
            doneButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        }
    }
    
    private func updateAppearanceFavoriteButton() {
        if self.favorite {
            favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
    
    func cellConfig(data: Shopping) {
        titleLabel.text = data.title
    }
    
}
