//
//  Protocols.swift
//  SeSACRxThreads_Start
//
//  Created by 권대윤 on 8/3/24.
//

import Foundation

protocol ShoppingTableViewHeaderCellDelegate: AnyObject {
    func addButtonTapped(sender: ShoppingTableViewHeaderCell)
}

protocol ShoppingTableViewCellDelegate: AnyObject {
    func doneButtonTapped(sender: ShoppingTableViewCell)
    
    func favoriteButtonTapped(sender: ShoppingTableViewCell)
}
