//
//  ShoppingViewController.swift
//  SeSACRxThreads_Start
//
//  Created by 권대윤 on 8/3/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import RxDataSources


struct MyData: IdentifiableType, Equatable {
    var identity: String

    typealias Identity = String

    var title: String
    var done: Bool = false
    var favorite: Bool = false
    var date: Date
}

struct MySection {
    var header: String
    var items: [Shopping]
}

extension MySection: AnimatableSectionModelType {
    
    init(original: MySection, items: [Shopping]) {
        self = original
        self.items = items
    }

    var identity: String {
        return header
    }

    typealias Item = Shopping
}


final class ShoppingViewController: BaseViewController {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    private let viewModel = ShoppingViewModel()
    
    private lazy var input = ShoppingViewModel.Input(modelDeleted: tableView.rx.modelDeleted(Shopping.self), modelSelected: tableView.rx.modelSelected(Shopping.self), search: searchBar.rx.text.orEmpty)
    
        var dataSource: RxTableViewSectionedAnimatedDataSource<MySection>!
        var sections = [
            MySection(header: "A", items: [])
        ]
        private var subject = PublishSubject<[MySection]>()
    
    lazy var test = Observable<[MySection]>.just(self.sections)
    
    
    
    //MARK: - UI Components
    
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.register(ShoppingTableViewCell.self, forCellReuseIdentifier: ShoppingTableViewCell.identifier)
//        tv.register(ShoppingTableViewHeaderCell.self, forHeaderFooterViewReuseIdentifier: ShoppingTableViewHeaderCell.identifier)
                tv.register(ShoppingTableViewHeaderCell.self, forCellReuseIdentifier: ShoppingTableViewHeaderCell.identifier)
        tv.sectionHeaderHeight = 120
        tv.keyboardDismissMode = .onDrag
        return tv
    }()
    
    private let searchBar = UISearchBar()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Configurations
    
    override func bind() {
        
        let output = viewModel.transform(input: self.input)
        
//        output.shoppingList
//            .bind(to: tableView.rx.items(cellIdentifier: ShoppingTableViewCell.identifier, cellType: ShoppingTableViewCell.self)) { row, element, cell in
//                cell.cellConfig(data: element)
//                cell.shopping = element
//                cell.done = element.done
//                cell.favorite = element.favorite
//                cell.delegate = self
//            }
//            .disposed(by: disposeBag)
        
//        tableView.rx.itemDeleted
//            .subscribe(with: self, onNext: { owner, indexPath in
//                //                guard var sections = try? owner.sections.value() else { return }
//                var items = self.sections[indexPath.section].items
//                items.remove(at: indexPath.row)
//                self.sections[indexPath.section] = MySection(original: self.sections[indexPath.section], items: items)
//                //                owner.sections.onNext(sections)
//                self.subject.onNext([])
//            })
//            .disposed(by: disposeBag)
        
        output.shoppingList
            .subscribe(with: self) { owner, list in
                owner.sections[0] = MySection(header: "A", items: list)
                self.subject.onNext(self.sections)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        output.modelSelected
            .bind(with: self, onNext: { owner, data in
                let vc = ShoppingDetailViewController()
                
                vc.viewModel.loadShopping.onNext(data)
                
                vc.viewModel.onDataUpdate = { [weak self] in
                    guard let self else { return }
                    self.tableView.reloadData()
                }
                
                owner.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        // dataSource 정의
        let dataSource = RxTableViewSectionedAnimatedDataSource<MySection>(animationConfiguration: AnimationConfiguration(insertAnimation: .fade, reloadAnimation: .fade, deleteAnimation: .left)) { dataSource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: ShoppingTableViewCell.identifier, for: indexPath) as! ShoppingTableViewCell
            
            cell.cellConfig(data: item)
            cell.shopping = item
            cell.done = item.done
            cell.favorite = item.favorite
            cell.delegate = self
            return cell
        }
        
        dataSource.canMoveRowAtIndexPath = { dataSource, index in
            return false
        }
        
        dataSource.canEditRowAtIndexPath = { dataSource, index in
            return true
        }
        
        self.dataSource = dataSource
        
        // 처음값 초기화
//        Observable.just(self.sections)
//            .bind(to: tableView.rx.items(dataSource: dataSource))
//            .disposed(by: disposeBag)
        
        subject
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    override func setupNavi() {
        navigationItem.title = "쇼핑"
        navigationItem.titleView = searchBar
    }
    
    override func configureLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }
    
    //MARK: - Methods
    
    private func showAddFailedAlert() {
        let alert = UIAlertController(title: "알림", message: "항목명을 입력해주세요.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        self.present(alert, animated: true)
    }
    
}

//MARK: - UITableViewDelegate

extension ShoppingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ShoppingTableViewHeaderCell.identifier) as! ShoppingTableViewHeaderCell
        cell.delegate = self
        
        cell.collectionView.rx.modelSelected(String.self)
            .bind(with: self) { owner, title in
                owner.input.addButtonTap.onNext(title)
            }
            .disposed(by: disposeBag)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        150
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { [weak self] (action, view, completionHandler) in
            guard let self else { return }
            
            self.tableView.dataSource?.tableView?(self.tableView, commit: .delete, forRowAt: indexPath)
            
            completionHandler(true)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "수정") { [weak self] (action, view, completionHandler) in
            guard let self else { return }
            
            self.tableView.delegate?.tableView?(self.tableView, didSelectRowAt: indexPath)
            
            completionHandler(true)
        }
        
        editAction.backgroundColor = .black
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }
}

//MARK: - ShoppingTableViewHeaderCellDelegate

extension ShoppingViewController: ShoppingTableViewHeaderCellDelegate {
    
    func addButtonTapped(sender: ShoppingTableViewHeaderCell) {
        guard let title = sender.titleTextField.text, !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            self.showAddFailedAlert()
            return
        }
        
        self.input.addButtonTap.onNext(title)
    }
}

//MARK: - ShoppingTableViewCellDelegate

extension ShoppingViewController: ShoppingTableViewCellDelegate {
    
    func doneButtonTapped(sender: ShoppingTableViewCell) {
        guard let data = sender.shopping else { return }
        self.input.doneButtonTap.onNext(data)
    }
    
    func favoriteButtonTapped(sender: ShoppingTableViewCell) {
        guard let data = sender.shopping else { return }
        self.input.favoriteButtonTap.onNext(data)
    }
}
