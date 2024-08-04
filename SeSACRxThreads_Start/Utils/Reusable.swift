//
//  Reusable.swift
//  SeSACRxThreads_Start
//
//  Created by 권대윤 on 8/3/24.
//

import UIKit

protocol Reusable: AnyObject {
    static var identifier: String { get }
}

extension UIView: Reusable {
    static var identifier: String {
        return String(describing: self)
    }
}
