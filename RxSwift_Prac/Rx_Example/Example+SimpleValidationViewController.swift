//
//  SimpleValidationViewController.swift
//  RxSwift_Prac
//
//  Created by 최승범 on 7/31/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

private let minimalUsernameLength = 5
private let minimalPasswordLength = 5

final class ExampleSimpleValidationViewController: UIViewController {
    
    private let userNameTextFiled = UITextField()
    private let userNameValidLabel = UILabel()
    
    private let passwordTextFiled = UITextField()
    private let passwordValidLabel = UILabel()
    
    private let doSomethingButton = UIButton()
    
    private let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configure()
        add()
    }
    
    private func add() {
        
        userNameValidLabel.text = "Username has to be at least \(minimalUsernameLength) characters"
        passwordValidLabel.text = "Password has to be at least \(minimalPasswordLength) characters"

        let usernameValid = userNameTextFiled.rx.text.orEmpty
            .map { $0.count >= minimalUsernameLength }
            .share(replay: 1)

        let passwordValid = passwordTextFiled.rx.text.orEmpty
            .map { $0.count >= minimalPasswordLength }
            .share(replay: 1)

        let everythingValid = Observable.combineLatest(usernameValid, passwordValid) { $0 && $1 }
            .share(replay: 1)

        usernameValid
            .bind(to: passwordTextFiled.rx.isEnabled)
            .disposed(by: disposeBag)

        usernameValid
            .bind(to: userNameTextFiled.rx.isHidden)
            .disposed(by: disposeBag)

        passwordValid
            .bind(to: passwordValidLabel.rx.isHidden)
            .disposed(by: disposeBag)

        everythingValid
            .bind(to: doSomethingButton.rx.isEnabled)
            .disposed(by: disposeBag)

        doSomethingButton.rx.tap
            .subscribe(onNext: { [weak self] _ in self?.showAlert() })
            .disposed(by: disposeBag)
    }
    
    private func showAlert() {
        let alert = UIAlertController(
            title: "RxExample",
            message: "성공",
            preferredStyle: .alert
        )
        let defaultAction = UIAlertAction(title: "Ok",
                                          style: .default,
                                          handler: nil)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func configure() {
        
        view.addSubview(userNameTextFiled)
        view.addSubview(userNameValidLabel)
        view.addSubview(passwordTextFiled)
        view.addSubview(passwordValidLabel)
        view.addSubview(doSomethingButton)
        
    
        userNameTextFiled.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        userNameValidLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameTextFiled.snp.bottom).offset(20)
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        passwordTextFiled.snp.makeConstraints { make in
            make.top.equalTo(userNameValidLabel.snp.bottom).offset(20)
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        passwordValidLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextFiled.snp.bottom).offset(20)
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        doSomethingButton.snp.makeConstraints { make in
            make.top.equalTo(passwordValidLabel.snp.bottom).offset(20)
            make.size.equalTo(50)
        }
        
        
    }
}
