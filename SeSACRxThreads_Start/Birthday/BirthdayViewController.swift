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
    
    let viewModel = BirthdayViewModel()
    
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
        label.text = "8888년"
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
        let input = BirthdayViewModel.Input(pickerDate: birthDayPicker.rx.date, nextButtonTap: nextButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.yearText
            .bind(to: yearLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.monthText
            .bind(to: monthLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.dayText
            .bind(to: dayLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.setupToday
            .bind(to: birthDayPicker.rx.date)
            .disposed(by: disposeBag)
        
        output.validationAgeStatus
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
        
        output.nextButtonTap
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
