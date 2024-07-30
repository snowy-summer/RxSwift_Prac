//
//  TextFiledAndButtonViewController.swift
//  RxSwift_Prac
//
//  Created by 최승범 on 7/30/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class TextFiledAndButtonViewController: UIViewController {
    
    private let simpleName = UITextField()
    private let simpleEmail = UITextField()
    private let simpleLabel = UILabel()
    private let simpleButton = UIButton()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configure()
        setSign()
    }
    
    private func setSign() {
        
        Observable.combineLatest(simpleName.rx.text.orEmpty,
                                 simpleEmail.rx.text.orEmpty) { value1, value2 in
            return "이름은 \(value1)이고, 이메일은 \(value2)입니다."
        }
                                 .bind(to: simpleLabel.rx.text)
                                 .disposed(by: disposeBag)
        
        simpleName.rx.text.orEmpty
            .map { $0.count < 4 }
            .bind(to: simpleEmail.rx.isHidden, simpleButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        simpleEmail.rx.text.orEmpty
            .map { $0.count > 4 }
            .bind(to: simpleButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        simpleButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.showAlert()
            }.disposed(by: disposeBag)
    }
    
    private func showAlert() {
        
        let profileAlert = UIAlertController(title: "제목",
                                             message: "내용",
                                             preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "확인",
                                          style: .cancel)
        
        let cancelAction = UIAlertAction(title: "취소",
                                         style: .default)
        profileAlert.addAction(confirmAction)
        profileAlert.addAction(cancelAction)
        
        self.present(profileAlert,
                     animated: false)
    }
    
    
    private func configure() {
        
        view.addSubview(simpleName)
        view.addSubview(simpleEmail)
        view.addSubview(simpleButton)
        view.addSubview(simpleLabel)
        
        simpleName.backgroundColor = .red
        simpleEmail.backgroundColor = .green
        simpleButton.backgroundColor = .blue
        simpleLabel.backgroundColor = .lightGray
        
        simpleName.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        simpleEmail.snp.makeConstraints { make in
            make.top.equalTo(simpleName.snp.bottom).offset(20)
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        simpleButton.snp.makeConstraints { make in
            make.top.equalTo(simpleEmail.snp.bottom).offset(20)
            make.size.equalTo(50)
            make.centerX.equalTo(view.snp.centerX)
        }
        
        simpleLabel.snp.makeConstraints { make in
            make.top.equalTo(simpleButton.snp.bottom).offset(20)
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        
    }
}


