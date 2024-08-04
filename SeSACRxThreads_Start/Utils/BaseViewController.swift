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
        setupNavi()
        configureLayout()
        view.backgroundColor = .systemBackground
    }
    
    func bind() { }
    
    func setupNavi() { }
    
    func configureLayout() { }
    
    func showCompletionAlert() {
        let alert = UIAlertController(title: "알림", message: "성공!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
}
