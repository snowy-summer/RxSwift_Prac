//
//  TableViewController.swift
//  RxSwift_Prac
//
//  Created by 최승범 on 7/30/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class TableViewController: UIViewController {
    
    private let tableView = UITableView()
    private let simpleLabel = UILabel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configure()
        setTableView()
    }
    
    private func setTableView() {
        
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "Cell")
        
        let items = Observable.just([
            "First Item",
            "Second Item",
            "Third Item"
        ])

        items
        .bind(to: tableView.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = "\(element) @ row \(row)"
            return cell
        }
        .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(String.self)
            .map { data in
                "\(data)를 클릭했습니다."
            }.bind(to: simpleLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func configure() {
        
        view.addSubview(tableView)
        view.addSubview(simpleLabel)
        
        simpleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(simpleLabel.snp.bottom).offset(20)
            make.directionalHorizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        
    }
}

