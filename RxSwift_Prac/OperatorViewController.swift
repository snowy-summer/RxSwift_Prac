//
//  OperatorViewController.swift
//  RxSwift_Prac
//
//  Created by 최승범 on 7/30/24.
//

import UIKit
import RxSwift
import RxCocoa

/*
1) disposed(by: DisposeBag)
 - disposeBag 프로퍼티는 OperatorViewController가 deinit이 안된다면 계속 살아 있고, 메모리에 계속 존재
 - OperatorViewController가 만약에 deinit이 된다는건, 프로퍼티들이 다 정리 되었을 때만 deinit이 된다, 이때는 disposeBag이 메모리에서 해제 된다.
 
 2) dispose
 - deinit시에 메모리 해제가 아니라 즉시 해제 시켜 버린다.
 */
final class OperatorViewController: UIViewController {
    
    var dispose = DisposeBag()
    let list = [1,2,3,4,5,5,1,2]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        view.backgroundColor = .white
        
        // 반복과 반복의 숫자를 조절
        // take가 없는 경우 계속 반복됨
        
//        Observable
//            .repeatElement("반복")
//            .take(10)
//            .subscribe { value in
//                print("next: \(value)")
//            } onError: { error in
//                print(error)
//            } onCompleted: {
//                print("complete") // => disposed
//            } onDisposed: {
//                print("dispose")
//            }
//            .disposed(by: dispose)

        // error가 나오면 dispose가 실행이된다.
        // complete가 나오면 dispose가 실행이된다.


        testIntervalObservable()
    }
    
    private func testJustObservable() {
        
        Observable.just(list)
            .subscribe { value in
                print("next - \(value)")
            } onError: { error in
                print("error - \(error)")
            } onCompleted: {
                print("completed")
            } onDisposed: {
                print("dispose")
            }
            .disposed(by: dispose)
    }
    
    private func testIntervalObservable() {
        
        let incrementaValue = Observable<Int>
            .interval(.seconds(1), scheduler: MainScheduler.instance)
        
        incrementaValue
            .subscribe { value in
                print("next - \(value)")
            } onError: { error in
                print("error - \(error)")
            } onCompleted: {
                print("completed")
            } onDisposed: {
                print("dispose")
            }.disposed(by: dispose)

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.dispose = DisposeBag()
        }
    }
}



// 1. Observable, Observer, Subscibe, bind 키워드 뭔지 알기
// 2. BasicButtonVC 1>>>8 한 번 더 점검
// 3. PickerView, TableView, UISwitch, UItextField, UIButton
// 4. just, of, from, take
// 5. rx example 살펴보기
