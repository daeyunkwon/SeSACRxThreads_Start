//
//  ShppingRepository.swift
//  SeSACRxThreads_Start
//
//  Created by 권대윤 on 8/3/24.
//

import Foundation

import RealmSwift

final class ShoppingRepository {
    
    private let realm = try! Realm()
    
    
    func createItem(title: String) {
        
        let data = Shopping(title: title)
        
        do {
            try realm.write {
                realm.add(data)
                print("DEBUG: Realm Create Succeed")
            }
        } catch {
            print("DEBUG: Realm Create Failed")
        }
    }
    
    func fetchAllItem(dateAscending: Bool) -> Results<Shopping> {
        let list = realm.objects(Shopping.self).sorted(byKeyPath: Shopping.Key.date.rawValue, ascending: dateAscending)
        return list
    }
    
    func updateItem(data: Shopping, title: String) {
        do {
            try realm.write {
                
                let newValue = [
                    Shopping.Key.id.rawValue: data.id,
                    Shopping.Key.title.rawValue: title,
//                    Shopping.Key.done.rawValue: data.done,
//                    Shopping.Key.favorite.rawValue: data.favorite,
                ]
                
                realm.create(Shopping.self, value: newValue, update: .modified)
                print("DEBUG: Realm Update Succeed")
            }
        } catch {
            print("DEBUG: Realm Update Failed")
        }
    }
    
    func updateDone(data: Shopping) {
        var changeValue = data.done
        changeValue.toggle()
        do {
            try realm.write {
                realm.create(Shopping.self, value: [Shopping.Key.id.rawValue: data.id, Shopping.Key.done.rawValue: changeValue], update: .modified)
                print("DEBUG: Realm Update Done Succeed")
            }
        } catch {
            print("DEBUG: Realm Update Done Failed")
        }
    }
    
    func updateFavorite(data: Shopping) {
        var changeValue = data.favorite
        changeValue.toggle()
        do {
            try realm.write {
                realm.create(Shopping.self, value: [Shopping.Key.id.rawValue: data.id, Shopping.Key.favorite.rawValue: changeValue], update: .modified)
                print("DEBUG: Realm Update Done Succeed")
            }
        } catch {
            print("DEBUG: Realm Update Done Failed")
        }
    }
    
    func deleteItem(data: Shopping) {
        do {
            try realm.write({
                realm.delete(data)
                print("DEBUG: Realm Delete Succeed")
            })
        } catch {
            print("DEBUG: Realm Delete Failed")
        }
    }
    
}
