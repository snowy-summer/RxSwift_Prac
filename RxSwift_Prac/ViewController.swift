//
//  ViewController.swift
//  RxSwift_Prac
//
//  Created by 최승범 on 7/30/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class ViewController: UIViewController {
    
    private let tableView = UITableView()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureTableView()
        
        //Obsservable 이벤트 전달
        let items = Observable.just([
            "First Item",
            "Second Item",
            "Third Item"
        ])

        //Observer: 테이블 뷰에 데이터를 보여주는 형태로 이벤트를 처리한다.
        //그나마 Closure 구문이 Observer
        //bind == subscribe
        items
        .bind(to: tableView.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = "\(element) @ row \(row)"
            return cell
        }
        .disposed(by: disposeBag)
        
        testJust()
        testFrom()
//        testInterval()

    }


    private func configureTableView() {
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.directionalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "Cell")
        
        // index 추출
        tableView.rx.itemSelected
            .bind { value in
                print("\(value)")
            }
            .disposed(by: disposeBag)
        
        // 데이터 추출
        tableView.rx.modelSelected(String.self)
            .bind { value in
                print(value)
            }
            .disposed(by: disposeBag)
        
        // index와 데이터 통합 추출
        Observable.zip(tableView.rx.itemSelected,
                       tableView.rx.modelSelected(String.self))
        .bind { value in
            print(value)
        }
        .disposed(by: disposeBag)
    }
    
    private func testJust() {
        // 언제 끝날지 몰라서 completer나 dispose가 호출이 안된다.
        Observable.just([1,2,3,4]) //Finite Observable Sequence
            .subscribe { value in
                print("next \(value)")
            } onError: { error in
                print(error)
            } onCompleted: {
                print("compelte")
            } onDisposed: { // 이벤트 아님
                print("dispose")
            }.disposed(by: disposeBag)

    }
    
    private func testFrom() {
        Observable.from([1,2,3,4]) //Finite Observable Sequence
            .subscribe { value in
                print("next \(value)")
            } onError: { error in
                print(error)
            } onCompleted: {
                print("compelte")
            } onDisposed: { // 이벤트 아님
                print("dispose")
            }.disposed(by: disposeBag)

    }
    
    private func testInterval() {
        Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance) //Infinite Observable Sequence
            .subscribe { value in
                print("next \(value)")
            } onError: { error in
                print(error)
            } onCompleted: {
                print("compelte")
            } onDisposed: { // 이벤트 아님
                print("dispose")
            }.disposed(by: disposeBag)

    }
    
}

