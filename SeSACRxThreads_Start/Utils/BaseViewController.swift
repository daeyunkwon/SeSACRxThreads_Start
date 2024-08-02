//
//  BaseViewController.swift
//  SeSACRxThreads_Start
//
//  Created by 권대윤 on 8/1/24.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        configureLayout()
        view.backgroundColor = .white
    }
    
    func bind() { }
    
    func configureLayout() { }
    
}
