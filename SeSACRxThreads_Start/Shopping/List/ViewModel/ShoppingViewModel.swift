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
    
    let loadItem = BehaviorSubject<Void>(value: ())
    
    let addItem = PublishSubject<String>()
    
    let updateDone = PublishSubject<Shopping>()
    let updateFavorite = PublishSubject<Shopping>()
    
    let deleteItem = PublishSubject<Shopping>()
    
    let searchItem = PublishSubject<String>()
    
    let first = PublishSubject<Bool>()
    let second = PublishSubject<Int>()
    
    //MARK: - Outputs
    
    private(set) var shoppingList = BehaviorRelay<[Shopping]>(value: [])
    
    //MARK: - Init
    
    init() {
        Observable.combineLatest(first, second) { value1, value2 in
            return "\(value1), \(value2)"
        }
        .bind { value in
            print(value)
        }
        .disposed(by: disposeBag)
        
        first.onNext(false)
        second.onNext(22)
        second.onNext(23)
        first.onNext(true)
        
        
        
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
        
        searchItem
            .debounce(.seconds(0), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, value in
                if value.isEmpty {
                    owner.fetchData()
                } else {
                    let result = owner.repository.fetchItemWithSearchTitle(searchKeyword: value)
                    owner.shoppingList.accept(Array(result))
                }
            }
            .disposed(by: disposeBag)
    }
    
    //MARK: - Methods
    
    private func fetchData() {
        let result = repository.fetchAllItem(dateAscending: false)
        shoppingList.accept(Array(result))
    }
    
}
