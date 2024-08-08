//
//  ShoppingCollectionViewCell.swift
//  SeSACRxThreads_Start
//
//  Created by 권대윤 on 8/7/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class ShoppingCollectionViewCell: UICollectionViewCell {
    
    private let backView = UIView()
    
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        contentView.addSubview(backView)
//        backView.snp.makeConstraints { make in
//            make.top.bottom.equalToSuperview().inset(10)
//            make.leading.equalToSuperview()
//        }
        
//        backView.addSubview(label)
//        label.snp.makeConstraints { make in
//            make.centerY.equalToSuperview()
//            make.leading.equalTo(backView.snp.leading).offset(10)
//            make.trailing.equalTo(backView.snp.trailing).offset(-10)
//        }
        
//        backView.backgroundColor = .systemGray5
//        DispatchQueue.main.async {
//            self.backView.layer.cornerRadius = self.backView.bounds.height / 2
//        }
//        label.font = .systemFont(ofSize: 14)
//        backgroundColor = .white
        
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(5)
            make.horizontalEdges.equalToSuperview().inset(10)
        }
        
        contentView.backgroundColor = .systemGray5
        DispatchQueue.main.async {
            self.contentView.layer.cornerRadius = self.contentView.bounds.height / 2
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


