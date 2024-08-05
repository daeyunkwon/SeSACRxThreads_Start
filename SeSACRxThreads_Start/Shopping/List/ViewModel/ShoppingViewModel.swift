//
//  ShoppingViewModel.swift
//  SeSACRxThreads_Start
//
//  Created by 권대윤 on 8/3/24.
//

import Foundation

import RealmSwift
import RxSwift
import RxCocoa

final class ShoppingViewModel {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    private let repository = ShoppingRepository()
    
    //MARK: - Inputs
    
    struct Input {
        let modelDeleted: ControlEvent<Shopping>
        let modelSelected: ControlEvent<Shopping>
        let search: ControlProperty<String>
        let addButtonTap = PublishSubject<String>()
        let doneButtonTap = PublishSubject<Shopping>()
        let favoriteButtonTap = PublishSubject<Shopping>()
    }
    
    //MARK: - Outputs
    
    struct Output {
        let shoppingList: BehaviorSubject<[Shopping]>
        let modelSelected: ControlEvent<Shopping>
    }
    
    //MARK: - Methods
    
    private func fetchData() -> [Shopping] {
        let result = repository.fetchAllItem(dateAscending: false)
        return Array(result)
    }
    
    func transform(input: Input) -> Output {
        let shoppingList = BehaviorSubject<[Shopping]>(value: [])
        
        let loadItem = BehaviorSubject<Void>(value: ())
        let addItem = PublishSubject<String>()
        let updateDone = PublishSubject<Shopping>()
        let updateFavorite = PublishSubject<Shopping>()
        let deleteItem = PublishSubject<Shopping>()
        let searchItem = PublishSubject<String>()
        
        loadItem
            .bind(with: self) { owner, _ in
                shoppingList.onNext(owner.fetchData())
            }
            .disposed(by: disposeBag)
        
        addItem
            .bind(with: self) { owner, value in
                owner.repository.createItem(title: value)
                shoppingList.onNext(owner.fetchData())
            }
            .disposed(by: disposeBag)
        
        updateDone
            .bind(with: self) { owner, value in
                owner.repository.updateDone(data: value)
                shoppingList.onNext(owner.fetchData())
            }
            .disposed(by: disposeBag)
        
        updateFavorite
            .bind(with: self) { owner, value in
                owner.repository.updateFavorite(data: value)
                shoppingList.onNext(owner.fetchData())
            }
            .disposed(by: disposeBag)
        
        deleteItem
            .bind(with: self) { owner, value in
                owner.repository.deleteItem(data: value)
                shoppingList.onNext(owner.fetchData())
            }
            .disposed(by: disposeBag)
        
        searchItem
            .debounce(.seconds(0), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, value in
                if value.isEmpty {
                    shoppingList.onNext(owner.fetchData())
                } else {
                    let result = owner.repository.fetchItemWithSearchTitle(searchKeyword: value)
                    shoppingList.onNext(Array(result))
                }
            }
            .disposed(by: disposeBag)
        
        input.modelDeleted
            .bind(to: deleteItem)
            .disposed(by: disposeBag)
        
        input.search
            .bind(to: searchItem)
            .disposed(by: disposeBag)
        
        input.addButtonTap
            .bind(to: addItem)
            .disposed(by: disposeBag)
        
        input.doneButtonTap
            .bind(to: updateDone)
            .disposed(by: disposeBag)
        
        input.favoriteButtonTap
            .bind(to: updateFavorite)
            .disposed(by: disposeBag)
        
        
        return Output(shoppingList: shoppingList, modelSelected: input.modelSelected)
    }
    
}
