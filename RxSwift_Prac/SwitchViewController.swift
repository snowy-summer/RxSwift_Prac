//
//  SwitchViewController.swift
//  RxSwift_Prac
//
//  Created by 최승범 on 7/30/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class SwitchViewController: UIViewController {
    
    private let simpleSwitch = UISwitch()
    private let simpleLabel = UILabel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configure()
        setSwitch()
    }
    
    private func setSwitch() {
        
        // switch의 값이 false
        Observable.of(false)
            .bind(to: simpleSwitch.rx.isOn)
            .disposed(by: disposeBag)
        
        simpleSwitch.rx.isOn
            .map { isOn in
                return isOn ? "켜짐" : "꺼짐"
            }
            .bind(to: simpleLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func configure() {
        
        view.addSubview(simpleSwitch)
        view.addSubview(simpleLabel)
        
        simpleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        simpleSwitch.snp.makeConstraints { make in
            make.top.equalTo(simpleLabel.snp.bottom).offset(20)
        }
        
        
    }
}

