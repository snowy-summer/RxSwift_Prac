//
//  PickerViewController.swift
//  RxSwift_Prac
//
//  Created by 최승범 on 7/30/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class PickerViewController: UIViewController {
    
    private let pickerView = UIPickerView()
    private let simpleLabel = UILabel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configure()
        setPickerView()
    }
    
    private func setPickerView() {
        
        let items = Observable.just([
            "영화",
            "애니",
            "드라마",
            "뮤지컬"
        ])
        
        items.bind(to: pickerView.rx.itemTitles) { (row, element) in
            return element
        }.disposed(by: disposeBag)
        
        pickerView.rx.modelSelected(String.self)
            .map { $0.description }
            .bind(to: simpleLabel.rx.text)
            .disposed(by: disposeBag)
        
    }
    
    private func configure() {
        
        view.addSubview(pickerView)
        view.addSubview(simpleLabel)
        
        pickerView.snp.makeConstraints { make in
            make.center.equalTo(view.snp.center)
        }
        
        simpleLabel.snp.makeConstraints { make in
            make.top.equalTo(pickerView.snp.bottom)
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
    }
}
