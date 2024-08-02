//
//  BirthdayViewController.swift
//  SeSACRxThreads_Start
//
//  Created by 권대윤 on 8/2/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

class BirthdayViewController: BaseViewController {
    
    //MARK: - Properties
    
    let disposeBag = DisposeBag()
    
    let todayInitialValue = Observable.just(Date())
    
    let year = PublishRelay<Int>()
    let month = PublishRelay<Int>()
    let day = PublishRelay<Int>()
    
    let ageValidationStatus = PublishSubject<Int>()
    
    //MARK: - UI Components
    
    let birthDayPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        picker.maximumDate = Date()
        return picker
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.text = "만 17세 이상만 가입 가능합니다."
        return label
    }()
    
    let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 10
        return stack
    }()
    
    let yearLabel: UILabel = {
        let label = UILabel()
        label.text = "2023년"
        label.textColor = UIColor.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let monthLabel: UILabel = {
        let label = UILabel()
        label.text = "33월"
        label.textColor = UIColor.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let dayLabel: UILabel = {
        let label = UILabel()
        label.text = "99일"
        label.textColor = UIColor.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let nextButton = PointButton(title: "가입하기")
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Configurations
    
    override func bind() {
        year
            .map { "\($0)년" }
            .bind(to: yearLabel.rx.text)
            .disposed(by: disposeBag)
        
        month
            .map { "\($0)월" }
            .bind(to: monthLabel.rx.text)
            .disposed(by: disposeBag)
        
        day
            .map { "\($0)일" }
            .bind(to: dayLabel.rx.text)
            .disposed(by: disposeBag)
        
        todayInitialValue
            .bind(with: self) { owner, value in
                owner.birthDayPicker.date = value
                
                let dateComponent = Calendar.current.dateComponents([.year, .month, .day], from: value)
                
                owner.year.accept(dateComponent.year ?? 0)
                owner.month.accept(dateComponent.month ?? 0)
                owner.day.accept(dateComponent.day ?? 0)
            }
            .disposed(by: disposeBag)
        
        ageValidationStatus
            .map { $0 >= 17 }
            .bind(with: self) { owner, value in
                owner.nextButton.isEnabled = value
                
                if value {
                    owner.nextButton.backgroundColor = UIColor.systemBlue
                    owner.infoLabel.text = "가입 가능한 나이입니다."
                    owner.infoLabel.textColor = .systemBlue
                } else {
                    owner.nextButton.backgroundColor = UIColor.lightGray
                    owner.infoLabel.text = "만 17세 이상만 가입 가능합니다."
                    owner.infoLabel.textColor = .systemRed
                }
            }
            .disposed(by: disposeBag)
        
        birthDayPicker.rx.date
            .map { Calendar.current.dateComponents([.year, .month, .day], from: $0) }
            .bind(with: self) { owner, value in
                //만나이 계산법: 현재 연도에서 출생 연도를 뺀 다음, 생일이 지났으면 그대로, 지나지 않았으면 1년을 더 빼기
                let todayComponent = Calendar.current.dateComponents([.year, .month, .day], from: Date())
                
                var age = (todayComponent.year ?? 0) - (value.year ?? 0)
                
                if value.month ?? 0 < todayComponent.month ?? 0 {
                    age -= 1
                } else if value.month ?? 0 == todayComponent.month ?? 0 {
                    if value.day ?? 0 < todayComponent.day ?? 0 {
                        age -= 1
                    }
                }
                
                owner.ageValidationStatus.onNext(age)
            }
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.showCompletionAlert()
            }
            .disposed(by: disposeBag)
    }
    
    override func configureLayout() {
        view.addSubview(infoLabel)
        view.addSubview(containerStackView)
        view.addSubview(birthDayPicker)
        view.addSubview(nextButton)
        
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            $0.centerX.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        [yearLabel, monthLabel, dayLabel].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        birthDayPicker.snp.makeConstraints {
            $0.top.equalTo(containerStackView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(birthDayPicker.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
