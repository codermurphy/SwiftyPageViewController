//
//  ViewController.swift
//  SwiftyPageViewController
//
//  Created by Qihe_mac on 2020/7/14.
//  Copyright © 2020 QiHe. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var contentView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
        self.contentView.dataSource = self
        self.contentView.delegate = self
    }
    
    private let styles: [String] = ["stype1","stype2","stype3"]

}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.styles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = self.styles[indexPath.row]
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = element
        return cell
    }
    
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let next = MPPageStype1ViewController()
            self.navigationController?.pushViewController(next, animated: true)
        default:
            break
        }
    }
}
