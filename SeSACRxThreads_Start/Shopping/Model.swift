//
//  Model.swift
//  SeSACRxThreads_Start
//
//  Created by 권대윤 on 8/3/24.
//

import Foundation

import RealmSwift

class Shopping: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    
    @Persisted var title: String
    @Persisted var done: Bool = false
    @Persisted var favorite: Bool = false
    @Persisted var date: Date
    
    
    convenience init(title: String) {
        self.init()
        self.title = title
        self.done = false
        self.favorite = false
        self.date = Date()
    }
    
    enum Key: String {
        case id
        case title
        case done
        case favorite
        case date
    }
}
