//
//  ShoppingTableViewHeaderCell.swift
//  SeSACRxThreads_Start
//
//  Created by 권대윤 on 8/3/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class ShoppingTableViewHeaderCell: UITableViewCell {
    
    //MARK: - Properties
    
    let viewModel = ShoppingTableViewHeaderCellViewModel()
    
    let disposeBag = DisposeBag()
    
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
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(ShoppingCollectionViewCell.self, forCellWithReuseIdentifier: ShoppingCollectionViewCell.identifier)
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    //MARK: - Init
    
    //UITableViewHeaderFooterView용 -> RxDataSources로 섹셩 구성할 시 필요 X
//    override init(reuseIdentifier: String?) {
//        super.init(reuseIdentifier: reuseIdentifier)
//        contentView.backgroundColor = .systemBackground
//        configureLayout()
//    }
    
    //UITableViewCell용 -> RxDataSources로 섹셩 구성할 시 필요 O
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
        configureLayout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        let setupData = PublishSubject<Void>()
        
        let input = ShoppingTableViewHeaderCellViewModel.Input(setupData: setupData)
        let output = viewModel.transfrom(input: input)
        
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        output.recentList
            .bind(to: collectionView.rx.items(cellIdentifier: ShoppingCollectionViewCell.identifier, cellType: ShoppingCollectionViewCell.self)) { row, element, cell in
                cell.label.text = element
            }
            .disposed(by: disposeBag)
    }
    
    private func configureLayout() {
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalToSuperview()
            make.height.equalTo(100)
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
        
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
    //MARK: - Actions
    
    @objc private func addButtonTapped() {
        self.delegate?.addButtonTapped(sender: self)
    }
    
}

extension ShoppingTableViewHeaderCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let item = try? collectionView.rx.model(at: indexPath) as String else {
            return CGSize(width: collectionView.frame.width, height: 50)
        }
    
        let width = calculateWidth(for: item)
        return CGSize(width: width + 20, height: 50)
    }
    
    private func calculateWidth(for item: String) -> CGFloat {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.text = item
        
        return label.intrinsicContentSize.width
    }
}
