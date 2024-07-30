//
//  OperatorViewController.swift
//  RxSwift_Prac
//
//  Created by 최승범 on 7/30/24.
//

import UIKit
import RxSwift
import RxCocoa

final class OperatorViewController: UIViewController {
    
    let dispose = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        view.backgroundColor = .white
        
        // 반복과 반복의 숫자를 조절
        // take가 없는 경우 계속 반복됨
        
        Observable
            .repeatElement("반복")
            .take(10)
            .subscribe { value in
                print("next: \(value)")
            } onError: { error in
                print(error)
            } onCompleted: {
                print("complete") // => disposed
            } onDisposed: {
                print("dispose")
            }
            .disposed(by: dispose)

        // error가 나오면 dispose가 실행이된다.
        // complete가 나오면 dispose가 실행이된다.

        
    }
}



// 1. Observable, Observer, Subscibe, bind 키워드 뭔지 알기
// 2. BasicButtonVC 1>>>8 한 번 더 점검
// 3. PickerView, TableView, UISwitch, UItextField, UIButton
// 4. just, of, from, take
// 5. rx example 살펴보기
