//
//  ShoppingDetailViewModel.swift
//  SeSACRxThreads_Start
//
//  Created by 권대윤 on 8/4/24.
//

import Foundation

import RxSwift

final class ShoppingDetailViewModel {
    
    //MARK: - Properties
    
    private let repository = ShoppingRepository()
    
    private let disposeBag = DisposeBag()
    
    private var shopping: Shopping?
    
    var onDataUpdate: () -> Void = { }
    
    //MARK: - Inputs
    
    var loadShopping = BehaviorSubject<Shopping?>(value: nil)
    
    var saveNewTitleText = PublishSubject<String>()
    
    //MARK: - Outputs
    
    private(set) var shoppingTitleText = BehaviorSubject<String?>(value: nil)
    
    //MARK: - Init
    
    init() {
        setupBind()
    }
    
    private func setupBind() {
        
        loadShopping
            .bind(with: self) { owner, shopping in
                guard let data = shopping else { return }
                owner.shopping = data
                
                owner.shoppingTitleText.onNext(data.title)
            }
            .disposed(by: disposeBag)
        
        saveNewTitleText
            .bind(with: self) { owner, value in
                guard let shopping = owner.shopping else { return }
                
                owner.repository.updateItem(data: shopping, title: value)
                owner.onDataUpdate()
            }
            .disposed(by: disposeBag)
    }
    
}
