//
//  UserViewController.swift
//  RxSwift_Prac
//
//  Created by 최승범 on 7/31/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class UserViewController: UIViewController {
    
    private let nicknameTextField = UITextField()
    private let checkButton = UIButton()
    
    // 전달만 가능, 이벤트.데이터를 못받는다.
    // observable과 observer를 동시에 할 수 있는 Subject
//    private let sampleNickname = Observable.just("별명")
    private let sampleNickname = BehaviorSubject(value: "콘칩")
    private let behavior = BehaviorSubject(value: 1)
    private let publish = PublishSubject<Int>() // 초기값이 없다
    private let reply = ReplaySubject<Int>.create(bufferSize: 2)
    private let asyncSubject = AsyncSubject<Int>()
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
//        testBehaviorSubject()
//        testPublishSubject()
//        testReplySubject()
//        testAsyncSubject()
        testCombineLatest()
        
        sampleNickname
            .bind(to: nicknameTextField.rx.text)
            .disposed(by: disposeBag)
        
        checkButton.rx.tap
            .bind(with: self) { owner, _ in
                
                //rx에서는 = 로 값을 변경하지 않는다.
                // 값을 변경하는 것도 이벤트를 전달하는 행위로 취급
                // next complete error 3개중에 1개인데
                // 값을 변경하는 것은 완료나 에러가 아니기 때문에 next
//                sampleNickname = "변경"
                owner.sampleNickname.onNext("변경 \(Int.random(in: 1...100))")
            }
            .disposed(by: disposeBag)
        
    }
    
    private func testPublishSubject() {
        
        //publisher는 subscribe를 설정하기 전의 값들은 전달이 안됨
        
        publish.onNext(2)
        publish.onNext(19)
        publish.onNext(494)
        
        publish
            .subscribe { value in
                print("publish next - \(value)")
            } onError: { error in
                print("publish error")
            } onCompleted: {
                print("publish onCompleted")
            } onDisposed: {
                print("publish onDisposed")
            }
            .disposed(by: disposeBag)
        
        // subscribe로 관계가 형성이 되어야지
        // 반영이 가능하다.
        publish.onNext(15)
        publish.onNext(55)
        publish.onCompleted() // 이벤트를 받아도 처리가 안됨
        publish.onNext(999)

        
    }
    
    private func testBehaviorSubject() {
        
        behavior.onNext(2)
        behavior.onNext(19)
        behavior.onNext(494)
        
        behavior
            .subscribe { value in
                print("behavior next - \(value)")
            } onError: { error in
                print("behavior error")
            } onCompleted: {
                print("behavior onCompleted")
            } onDisposed: {
                print("behavior onDisposed")
            }
            .disposed(by: disposeBag)
        
        // subscribe로 관계가 형성이 되어야지
        // 반영이 가능하다.
        behavior.onNext(15)
        behavior.onNext(55)
        behavior.onNext(999)

        
    }
    
    private func testReplySubject() {
        
        reply.onNext(100)
        reply.onNext(200)
        reply.onNext(300)
        reply.onNext(400)
        reply.onNext(500)
        reply.onNext(600)
        
        reply
            .subscribe { value in
                print("reply next - \(value)")
            } onError: { error in
                print("reply error")
            } onCompleted: {
                print("reply onCompleted")
            } onDisposed: {
                print("reply onDisposed")
            }
            .disposed(by: disposeBag)
        
        reply.onNext(1)
        reply.onNext(2)
        reply.onNext(6)
        
        reply.onCompleted()
        
        reply.onNext(222)
        reply.onNext(4444)
    }
    
    private func testAsyncSubject() {
        
        asyncSubject.onNext(100)
        asyncSubject.onNext(200)
        asyncSubject.onNext(300)
        asyncSubject.onNext(400)
        asyncSubject.onNext(500)
        asyncSubject.onNext(600)
        
        asyncSubject
            .subscribe { value in
                print("asyncSubject next - \(value)")
            } onError: { error in
                print("asyncSubject error")
            } onCompleted: {
                print("asyncSubject onCompleted")
            } onDisposed: {
                print("asyncSubject onDisposed")
            }
            .disposed(by: disposeBag)
        
        asyncSubject.onNext(1)
        asyncSubject.onNext(2)
        asyncSubject.onNext(6)
        
        asyncSubject.onCompleted()
        
        asyncSubject.onNext(222)
        asyncSubject.onNext(4444)
    }
    
    private func testCombineLatest() {
        let a = PublishSubject<Int>()
        let b = PublishSubject<String>()
        
        Observable.combineLatest(a,b) { c,d in
            return "\(c) + \(d)"
        }
        .subscribe(with: self) { owner, data in
            print(data)
        }
        .disposed(by: disposeBag)
        
        b.onNext("2")
        b.onNext("87")
        b.onNext("56")
        a.onNext(10)
    }
    
    private func configureView() {
        view.addSubview(nicknameTextField)
        view.addSubview(checkButton)
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(50)
        }
        
        checkButton.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(20)
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(50)
        }
        
        nicknameTextField.backgroundColor = .green
        checkButton.backgroundColor = .blue
    }
}
