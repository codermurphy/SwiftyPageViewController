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
    
    private let styles: [String] = ["无HeaderView-刷新在顶部","无HeaderView-刷新菜单栏底部","有HeaderView-刷新在顶部","有HeaderView-刷新在菜单栏底部","固定headerView","headerView放大","Menu在Navigation中(.auto无法使用-待解决)","Menu带有额外View"]

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
        for _ in 0..<count {
            controllers.append(Page1ViewController())
        }
        
        var menus: [MPMenuModel] = []
        for index in 0..<count{
            var item = MPMenuModel()
            item.title = "menu\(index)"
            menus.append(item)
        }
        
        let normalTextFont: MPMenuStyle = .normalTextFont(.systemFont(ofSize: 12))
        let selectedTextFont: MPMenuStyle = .selectedTextFont(.systemFont(ofSize: 15))
        let normalTextColor: MPMenuStyle = .normalTextColor(.gray)
        let selectedTextColor: MPMenuStyle = .normalTextColor(.blue)
        let itemSpace: MPMenuStyle = .itemSpace(20)
        let contentInset: MPMenuStyle = .contentInset(UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24))
        
        switch indexPath.row {
        case 0:
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
            
            let next = MPPageViewController(configs: configs, menuContents: menus, controllers: controllers,refreshPosition: .menuTop ,menuViewHeight: 40, defaultMenuPinHeight: 0, defaultIndex: 0)
            self.navigationController?.pushViewController(next, animated: true)
        case 1:

            let indicatorBackgroundColor: MPIndicatorStyle = .backgroundColor(.brown)
            let indicatorHeight: MPIndicatorStyle = .height(3)
            let indicatrIsHidden: MPIndicatorStyle = .hidden(false)
            let indicatorCornor: MPIndicatorStyle = .cornerRadius(1.5)
            let indicatorPosition: MPIndicatorStyle = .position(.top)
            let indicatorShape: MPIndicatorStyle = .shape(.line(isAutoWidth: true, width: 0))
            
            let indicatorStyle: MPMenuStyle = .indicatorStyle(MPIndicatorViewStyle(parts: indicatorBackgroundColor,indicatorHeight,indicatrIsHidden,indicatorCornor,indicatorPosition,indicatorShape))
            
            let bottomLineStyle: MPMenuStyle = .bottomLineStyle(MPBottomLineViewStyle(parts: .backgroundColor(.red),.height(1),.hidden(false)))
            
            let switchStyle: MPMenuStyle = .switchStyle(.line)
            let layoutStyle: MPMenuStyle = .layoutStyle(.auto)
            
            let configs = [normalTextFont,selectedTextFont,normalTextColor,selectedTextColor,itemSpace,contentInset,indicatorStyle,bottomLineStyle,switchStyle,layoutStyle]
        
            let next = MPPageViewController(configs: configs, menuContents: menus, controllers: controllers ,refreshPosition: .menuBottom,menuViewHeight: 40, defaultMenuPinHeight: 0, defaultIndex: 0)
            self.navigationController?.pushViewController(next, animated: true)
        case 2:
            let indicatorBackgroundColor: MPIndicatorStyle = .backgroundColor(.brown)
            let indicatorHeight: MPIndicatorStyle = .height(25)
            let indicatrIsHidden: MPIndicatorStyle = .hidden(false)
            let indicatorCornor: MPIndicatorStyle = .cornerRadius(12)
            let indicatorPosition: MPIndicatorStyle = .position(.center)
            let indicatorShape: MPIndicatorStyle = .shape(.line(isAutoWidth: true, width: 0))
            let extraWidth: MPIndicatorStyle = .extraWidth(20)
            let indicatorStyle: MPMenuStyle = .indicatorStyle(MPIndicatorViewStyle(parts: indicatorBackgroundColor,indicatorHeight,indicatrIsHidden,indicatorCornor,indicatorPosition,indicatorShape,extraWidth))
                
            let bottomLineStyle: MPMenuStyle = .bottomLineStyle(MPBottomLineViewStyle(parts: .backgroundColor(.red),.height(1),.hidden(false)))
                
            let switchStyle: MPMenuStyle = .switchStyle(.line)
            let layoutStyle: MPMenuStyle = .layoutStyle(.flex)
                
            let configs = [normalTextFont,selectedTextFont,normalTextColor,selectedTextColor,itemSpace,contentInset,indicatorStyle,bottomLineStyle,switchStyle,layoutStyle]
            
            let headerView = UIView()
            headerView.frame.size.height = 120
            headerView.backgroundColor = .green
            
            let next = MPPageViewController(configs: configs, menuContents: menus, controllers: controllers,headerView:headerView,refreshPosition: .headerTop,menuViewHeight: 40, defaultMenuPinHeight: 0, defaultIndex: 0)
            self.navigationController?.pushViewController(next, animated: true)
        case 3:
            
            var menus: [MPMenuModel] = []
            for index in 0..<count{
                var item = MPMenuModel()
                item.title = "menu\(index)"
                item.normalIcon = UIImage(named: "menu")
                item.selectedIcon = UIImage(named: "menu")
                menus.append(item)
            }
            
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
            
            let next = MPPageViewController(configs: configs, menuContents: menus, controllers: controllers ,headerView:headerView ,refreshPosition: .menuBottom,menuViewHeight: 40, defaultMenuPinHeight: 0, defaultIndex: 0)
            self.navigationController?.pushViewController(next, animated: true)
        case 4:
            
            var menus: [MPMenuModel] = []
            for index in 0..<count{
                var item = MPMenuModel()
                item.title = "menu\(index)"
                item.normalIcon = UIImage(named: "menu")
                item.selectedIcon = UIImage(named: "menu")
                menus.append(item)
            }
            
            let indicatorBackgroundColor: MPIndicatorStyle = .backgroundColor(.brown)
            let indicatorHeight: MPIndicatorStyle = .height(3)
            let originWidth: MPIndicatorStyle = .originWidth(70)
            let indicatrIsHidden: MPIndicatorStyle = .hidden(false)
            let indicatorCornor: MPIndicatorStyle = .cornerRadius(1.5)
            let indicatorPosition: MPIndicatorStyle = .position(.bottom)
            let indicatorShape: MPIndicatorStyle = .shape(.line(isAutoWidth: true, width: 0))
                
            let indicatorStyle: MPMenuStyle = .indicatorStyle(MPIndicatorViewStyle(parts: indicatorBackgroundColor,indicatorHeight,indicatrIsHidden,indicatorCornor,indicatorPosition,indicatorShape,originWidth))
                
            let bottomLineStyle: MPMenuStyle = .bottomLineStyle(MPBottomLineViewStyle(parts: .backgroundColor(.red),.height(1),.hidden(false)))
                
            let switchStyle: MPMenuStyle = .switchStyle(.telescopic)
            let layoutStyle: MPMenuStyle = .layoutStyle(.flex)
            
            let itemTextAndImageStyle: MPMenuStyle = .itemTextAndImageStyle(.right, 5)
                
            let configs = [normalTextFont,selectedTextFont,normalTextColor,selectedTextColor,itemSpace,contentInset,indicatorStyle,bottomLineStyle,switchStyle,layoutStyle,itemTextAndImageStyle]
            
            let headerView = UIView()
            headerView.frame.size.height = 120
            headerView.backgroundColor = .green
            
            let next = MPPageViewController(configs: configs, menuContents: menus, controllers: controllers ,headerView:headerView ,isFixedHeaderView: true,refreshPosition: .menuBottom,menuViewHeight: 40, defaultMenuPinHeight: 0, defaultIndex: 0)
            self.navigationController?.pushViewController(next, animated: true)
        case 5:
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
            
            let next = MPPageViewController(configs: configs, menuContents: menus, controllers: controllers ,headerView:headerView,isZooomHeaderView: true ,refreshPosition: .menuBottom,menuViewHeight: 40, defaultMenuPinHeight: 0, defaultIndex: 0)
            self.navigationController?.pushViewController(next, animated: true)
        case 6:
            let contentInset: MPMenuStyle = .contentInset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
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
            
            let headerView = UIView()
            headerView.frame.size.height = 120
            headerView.backgroundColor = .green
            
            let next = MPPageViewController(configs: configs, menuContents: menus, controllers: controllers ,headerView:headerView,isZooomHeaderView: true ,refreshPosition: .menuBottom,menuViewHeight: 40,menuPoision: .navigation(position: .center, width: 200),defaultMenuPinHeight: 0, defaultIndex: 0)
            next.menuView.backgroundColor = .clear
            self.navigationController?.pushViewController(next, animated: true)
        case 7:
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
            
            let extarView = MPPageNavigationItemContainer()
            extarView.backgroundColor = .red
            let next = MPPageViewController(configs: configs, menuContents: menus, controllers: controllers ,headerView:headerView,isZooomHeaderView: true ,refreshPosition: .menuBottom,menuViewHeight: 40,menuExtraView: extarView ,defaultMenuPinHeight: 0, defaultIndex: 0)
            self.navigationController?.pushViewController(next, animated: true)
        default:
            break
        }
    }
}
