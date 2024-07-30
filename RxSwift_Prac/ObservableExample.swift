//
//  ObservableExample.swift
//  RxSwift_Prac
//
//  Created by 최승범 on 7/30/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class ObservableExample: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        justExample()
        ofExample()
        fromExample()
        takeExample()
    }
    
    private func justExample() {
        
        let item = [3.3, 4.0, 5.0, 4.2, 6.2]
        
        Observable.just(item)
            .subscribe { value in
                print("just - \(value)")
            } onError: { error in
                print("just - \(error)")
            } onCompleted: {
                print("just Complete")
            } onDisposed: {
                print("just disposed")
            }
            .disposed(by: disposeBag)
        
    }
    
    private func ofExample() {
        
        let item = [3.3, 4.0, 5.0, 4.2, 6.2]
        let itemB = [4.2, 9.0, 9.9, 131.2, 111.2]
        
        Observable.of(item, itemB)
            .subscribe { value in
                print("of - \(value)")
            } onError: { error in
                print("of - \(error)")
            } onCompleted: {
                print("of Complete")
            } onDisposed: {
                print("of disposed")
            }
            .disposed(by: disposeBag)
        
    }
    
    private func fromExample() {
        
        let item = [3.3, 4.0, 5.0, 4.2, 6.2]
        
        Observable.from(item)
            .subscribe { value in
                print("from - \(value)")
            } onError: { error in
                print("from - \(error)")
            } onCompleted: {
                print("from Complete")
            } onDisposed: {
                print("from disposed")
            }
            .disposed(by: disposeBag)
        
    }
    
    private func takeExample() {
        
        
        Observable.repeatElement("반복중")
            .take(3)
            .subscribe { value in
                print("take - \(value)")
            } onError: { error in
                print("take - \(error)")
            } onCompleted: {
                print("take Complete")
            } onDisposed: {
                print("take disposed")
            }
            .disposed(by: disposeBag)
        
    }
}

