//
//  ShoppingViewModel.swift
//  SeSACRxThreads_Start
//
//  Created by 권대윤 on 8/3/24.
//

import Foundation

import RealmSwift
import RxSwift

final class ShoppingViewModel {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    private let repository = ShoppingRepository()
    
    //MARK: - Inputs
    
    let loadItem = BehaviorSubject<Void>(value: ())
    
    let addItem = PublishSubject<String>()
    
    let updateDone = PublishSubject<Shopping>()
    let updateFavorite = PublishSubject<Shopping>()
    
    let deleteItem = PublishSubject<Shopping>()
    
    //MARK: - Outputs
    
    private(set) var shoppingList = BehaviorSubject<[Shopping]>(value: [])
    
    //MARK: - Init
    
    init() {
        loadItem
            .bind(with: self) { owner, _ in
                owner.fetchData()
            }
            .disposed(by: disposeBag)
        
        addItem
            .bind(with: self) { owner, value in
                owner.repository.createItem(title: value)
                owner.fetchData()
            }
            .disposed(by: disposeBag)
        
        updateDone
            .bind(with: self) { owner, value in
                owner.repository.updateDone(data: value)
                owner.fetchData()
            }
            .disposed(by: disposeBag)
        
        updateFavorite
            .bind(with: self) { owner, value in
                owner.repository.updateFavorite(data: value)
                owner.fetchData()
            }
            .disposed(by: disposeBag)
        
        deleteItem
            .bind(with: self) { owner, value in
                owner.repository.deleteItem(data: value)
                owner.fetchData()
            }
            .disposed(by: disposeBag)
    }
    
    //MARK: - Methods
    
    private func fetchData() {
        let result = repository.fetchAllItem(dateAscending: false)
        shoppingList.onNext(Array(result))
    }
    
}
