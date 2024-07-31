//
//  PasswordViewController.swift
//  RxSwift_Prac
//
//  Created by 최승범 on 7/31/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class PasswordViewController: UIViewController {
    
    private let passwordTextFiled = UITextField()
    private let nextButton = UIButton()
    private let descriptionLabel = UILabel()
    
    private let validText = Observable.just("8자 이상 입력하세요")
    private let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureLayout()
        bind()
    }
    
    func bind() {
        validText
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        let validation = passwordTextFiled.rx.text.orEmpty
            .map { $0.count >= 8}
        
        validation
            .bind(with: self) { owner, value in
                let color: UIColor = value ? .systemPink : .lightGray
                owner.nextButton.backgroundColor = color
            }
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                print("show alert")
            }
            .disposed(by: disposeBag)
    }
    
    private func configureLayout() {
        view.addSubview(passwordTextFiled)
        view.addSubview(nextButton)
        view.addSubview(descriptionLabel)
        
        passwordTextFiled.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.equalTo(passwordTextFiled.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextFiled.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
