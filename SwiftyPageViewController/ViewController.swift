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
        let count = Int.random(in: 0...10)
        var controllers: [UIViewController & MPChildViewControllerProtocol] = []
        for _ in 0..<2 {
            controllers.append(Page1ViewController())
        }
        
        var menus: [MPMenuModel] = []
        for index in 0..<2 {
            var item = MPMenuModel()
            item.title = "menu\(index)"
            menus.append(item)
        }
        
        let normalTextFont: MPMenuStyle = .normalTextFont(.systemFont(ofSize: 12))
        let selectedTextFont: MPMenuStyle = .selectedTextFont(.systemFont(ofSize: 12))
        let normalTextColor: MPMenuStyle = .normalTextColor(.gray)
        let selectedTextColor: MPMenuStyle = .normalTextColor(.blue)
        let itemSpace: MPMenuStyle = .itemSpace(20)
        let contentInset: MPMenuStyle = .contentInset(UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24))
        
        switch indexPath.row {
        case 0:
            let next = MPPageStype1ViewController()
            self.navigationController?.pushViewController(next, animated: true)
        case 1:

            let indicatorBackgroundColor: MPIndicatorStyle = .backgroundColor(.brown)
            let indicatorHeight: MPIndicatorStyle = .height(3)
            let indicatrIsHidden: MPIndicatorStyle = .hidden(false)
            let indicatorCornor: MPIndicatorStyle = .cornerRadius(1.5)
            let indicatorPosition: MPIndicatorStyle = .position(.bottom)
            let indicatorShape: MPIndicatorStyle = .shape(.line(isAutoWidth: true, width: 0))
            
            let indicatorStyle: MPMenuStyle = .indicatorStyle(MPIndicatorViewStyle(parts: indicatorBackgroundColor,indicatorHeight,indicatrIsHidden,indicatorCornor,indicatorPosition,indicatorShape))
            
            let bottomLineStyle: MPMenuStyle = .bottomLineStyle(MPBottomLineViewStyle(parts: .backgroundColor(.red),.height(1),.hidden(false)))
            
            let switchStyle: MPMenuStyle = .switchStyle(.line)
            let layoutStyle: MPMenuStyle = .layoutStyle(.auto)
            
            let configs = [normalTextFont,selectedTextFont,normalTextColor,selectedTextColor,itemSpace,contentInset,indicatorStyle,bottomLineStyle,switchStyle,layoutStyle]
        
            let next = MPPageViewController(configs: configs, menuContents: menus, controllers: controllers ,menuViewHeight: 40, defaultMenuPinHeight: 0, defaultIndex: 0)
            self.navigationController?.pushViewController(next, animated: true)
        case 2:
            let indicatorBackgroundColor: MPIndicatorStyle = .backgroundColor(.brown)
            let indicatorHeight: MPIndicatorStyle = .height(3)
            let indicatrIsHidden: MPIndicatorStyle = .hidden(false)
            let indicatorCornor: MPIndicatorStyle = .cornerRadius(1.5)
            let indicatorPosition: MPIndicatorStyle = .position(.bottom)
            let indicatorShape: MPIndicatorStyle = .shape(.line(isAutoWidth: true, width: 0))
                
            let indicatorStyle: MPMenuStyle = .indicatorStyle(MPIndicatorViewStyle(parts: indicatorBackgroundColor,indicatorHeight,indicatrIsHidden,indicatorCornor,indicatorPosition,indicatorShape))
                
            let bottomLineStyle: MPMenuStyle = .bottomLineStyle(MPBottomLineViewStyle(parts: .backgroundColor(.red),.height(1),.hidden(false)))
                
            let switchStyle: MPMenuStyle = .switchStyle(.line)
            let layoutStyle: MPMenuStyle = .layoutStyle(.flex)
                
            let configs = [normalTextFont,selectedTextFont,normalTextColor,selectedTextColor,itemSpace,contentInset,indicatorStyle,bottomLineStyle,switchStyle,layoutStyle]
            
            let headerView = UIView()
            headerView.frame.size.height = 120
            headerView.backgroundColor = .green
            
            let next = MPPageViewController(configs: configs, menuContents: menus, controllers: controllers ,headerView:headerView ,menuViewHeight: 40, defaultMenuPinHeight: 0, defaultIndex: 0)
            self.navigationController?.pushViewController(next, animated: true)
            
        default:
            break
        }
    }
}
