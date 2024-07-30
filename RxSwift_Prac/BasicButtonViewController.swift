//
//  BasicButtonViewController.swift
//  RxSwift_Prac
//
//  Created by 최승범 on 7/30/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class BasicButtonViewController: UIViewController {
    
    let button = UIButton()
    let label = UILabel()
    
    let textField = UITextField()
    let secondLabel = UILabel()
    
    let dispose = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        button.backgroundColor = .red
        label.backgroundColor = .lightGray
        textField.backgroundColor = .lightGray
        secondLabel.backgroundColor = .lightGray
        configureView()
        
//       rx정리_첫번째예시()
       rx정리_두번째예시()
        
    }
    
    private func configureView() {
        
        view.addSubview(button)
        view.addSubview(label)
        view.addSubview(textField)
        view.addSubview(secondLabel)
        
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(50)
        }
        
        label.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.height.equalTo(100)
        }
        
        textField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
            make.top.equalTo(label.snp.bottom).offset(20)
        }
        
        secondLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
            make.top.equalTo(textField.snp.bottom).offset(20)
        }
    }
    
    
    private func rx정리_첫번째예시() {
        //infinite Observable Stream
        //1.
//        button.rx.tap
//            .subscribe { _ in
//                self.label.text = "버튼 클릭"
//            } onError: { error in
//                print(error)
//            } onCompleted: {
//                print("complete")
//            } onDisposed: {
//                print("dispose")
//            }.disposed(by: dispose)
        
        // 2. 필요 없는거 정리
//        button.rx.tap
//            .subscribe { _ in
//                self.label.text = "버튼 클릭"
//            } onDisposed: {
//                print("dispose")
//            }.disposed(by: dispose)
        
        //3. memory leak
//        button.rx.tap
//            .subscribe { [weak self] _ in
//                self?.label.text = "버튼 클릭"
//            } onDisposed: {
//                print("dispose")
//            }.disposed(by: dispose)
        
        //4. weak self 대신
//        button.rx.tap
//            .withUnretained(self)
//            .subscribe { _ in
//                self.label.text = "버튼 클릭"
//            } onDisposed: {
//                print("dispose")
//            }.disposed(by: dispose)
        
        //5. withUnretained 대신 사용
//        button.rx.tap
//            .subscribe(with: self) { owner, _ in
//                owner.label.text = "버튼 클릭"
//            } onError: { owner, error in
//                print(error)
//            } onCompleted: { owner in
//                print("complete")
//            } onDisposed: { owner in
//                print("dispose")
//            }.disposed(by: dispose)
        
        //6. UIkit
        //subscribe: 백그라운드에서도 동작이 가능, 항상 메인 스레드에서 동작하는 것은 아님
//        button.rx.tap
//            .subscribe(with: self) { owner, _ in
//                DispatchQueue.main.async {
//                    owner.label.text = "버튼 클릭"
//                }
//                
//            } onDisposed: { owner in
//                print("dispose")
//            }.disposed(by: dispose)
        
        //7. mainThread에서 동작 보장
//        button.rx.tap
//            .observe(on: MainScheduler.instance)
//            .subscribe(with: self) { owner, _ in
//                owner.label.text = "버튼 클릭"
//                
//            } onDisposed: { owner in
//                print("dispose")
//            }.disposed(by: dispose)
        
        //8. error가 없고 mainThread에서 사용하는 것을 보장하는 것
        // bind는 error, complete가 없다.
//        button.rx.tap
//            .bind(with: self) { owner, _ in
//                owner.label.text = "버튼 클릭"
//            }.disposed(by: dispose)
        
        //9.
        button.rx.tap.map { "버튼 클릭"} //Observable<String>
            .bind(to: label.rx.text)
            .disposed(by: dispose)
        
        //퀴즈.Button.rx.tap은 subscribe되면서 label.rx.text는 왜 안될까
        // button.rx.tap은 이벤트가 발생한 흐름이고 -> Observable이다
        // label.rx.text는 이벤트가 아니다.
    }
    
    private func rx정리_두번째예시() {
        
        // 2곳에 넣기
        button.rx.tap
            .map { "버튼 다시 클릭" }
            .bind(to: secondLabel.rx.text, textField.rx.text)
            .disposed(by: dispose)
        
        // textField의 값을 가지고 와서 label에 배치
        button.rx.tap
            .withLatestFrom(textField.rx.text)
            .bind(to: secondLabel.rx.text)
            .disposed(by: dispose)
        
            
                
            
    }
}
