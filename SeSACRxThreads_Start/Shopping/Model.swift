//
//  Model.swift
//  SeSACRxThreads_Start
//
//  Created by 권대윤 on 8/3/24.
//

import Foundation

import RealmSwift
import Differentiator

class Shopping: Object, IdentifiableType {
    var identity: String = UUID().uuidString
    typealias Identity = String
    
    @Persisted(primaryKey: true) var id: ObjectId
    
    @Persisted var title: String
    @Persisted var done: Bool = false
    @Persisted var favorite: Bool = false
    @Persisted var date: Date
    
    
    convenience init(title: String, done: Bool = false, favorite: Bool = false, date: Date = Date()) {
        self.init()
        self.title = title
        self.done = done
        self.favorite = favorite
        self.date = date
    }
    
    enum Key: String {
        case id
        case title
        case done
        case favorite
        case date
    }
}
