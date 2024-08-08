//
//  ShoppingTableViewHeaderCellViewModel.swift
//  SeSACRxThreads_Start
//
//  Created by 권대윤 on 8/8/24.
//

import Foundation

import RxSwift
import RxCocoa

final class ShoppingTableViewHeaderCellViewModel {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    private var recentList = ["키보드", "손풍기", "컵", "마우스패드", "비타민", "샌들", "헤드셋", "케이블"]
    
    //MARK: - Inputs
    
    struct Input {
        let setupData: PublishSubject<Void>
    }
    
    //MARK: - Outputs
    
    struct Output {
        let recentList: BehaviorSubject<[String]>
    }
    
    //MARK: - Methods
    
    func transfrom(input: Input) -> Output {
        
        let recentList = BehaviorSubject<[String]>(value: [])
        
        
        input.setupData
            .subscribe(with: self) { owner, _ in
                recentList.onNext(owner.recentList)
            }
            .disposed(by: disposeBag)
        
        input.setupData.onNext(())
        
        
            
        return Output(recentList: recentList)
    }
    
}
