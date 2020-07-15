//
//  Page3ViewController.swift
//  SwiftyPageViewController
//
//  Created by Qihe_mac on 2020/7/15.
//  Copyright © 2020 QiHe. All rights reserved.
//

import UIKit

class Page3ViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    

    private lazy var contentView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        return tableView
    }()

}

extension Page3ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = "page3 row: \(indexPath.row)"
        return cell
    }

}

extension Page3ViewController: MPChildViewControllerProtocol {
    func mp_ChildScrollView() -> UIScrollView {
        return self.contentView
    }
}
