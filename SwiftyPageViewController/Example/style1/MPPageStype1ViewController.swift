//
//  MPPageStype1ViewController.swift
//  SwiftyPageViewController
//
//  Created by Qihe_mac on 2020/7/15.
//  Copyright © 2020 QiHe. All rights reserved.
//

import UIKit

class MPPageStype1ViewController: MPPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.menuView.titles = [MPMenuModel(title: "page1"),MPMenuModel(title: "page2"),MPMenuModel(title: "page3"),MPMenuModel(title: "page4"),MPMenuModel(title: "page5")]
        self.menuView.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
    }
    

    // MARK: - UI
    lazy var menuView: MPMenuView = {
        let view = MPMenuView(parts:
            .normalTextColor(UIColor.gray),
            .selectedTextColor(UIColor.blue),
            .normalTextFont(UIFont.systemFont(ofSize: 15.0)),
            .selectedTextFont(UIFont.systemFont(ofSize: 15.0, weight: .medium)),
            .switchStyle(.line),
            .indicatorStyle(
                MPIndicatorViewStyle(parts:
                    .backgroundColor(.brown),
                    .height(30.0),
                    .cornerRadius(15),
                    .position(.center),
                    .extraWidth(15.0),
                    .shape(.line)
                )
            ),
            .bottomLineStyle(
                MPBottomLineViewStyle(parts:
                    .hidden(false)
                )
            ),
            .layoutStyle(.auto)
        )
        view.delegate = self
        return view
    }()
    
    
    // MARK: - override methods
    
    override func pageController(_ pageController: MPPageViewController, viewControllerAt index: Int) -> (UIViewController & MPChildViewControllerProtocol) {
        
        switch index {
        case 0:
            return Page1ViewController()
        case 1:
            return Page2ViewController()
        case 2:
            return Page3ViewController()
        case 3:
            return Page4ViewController()
        case 4:
            return Page5ViewController()
        default:
            return Page1ViewController()
        }
        
    }
    
    override func numberOfViewControllers(in pageController: MPPageViewController) -> Int {
        return 5
    }
    
    override func headerViewFor(_ pageController: MPPageViewController) -> UIView? {
        return nil
    }
    
    override func headerViewHeightFor(_ pageController: MPPageViewController) -> CGFloat {
        return 0
    }
    
    override func menuViewFor(_ pageController: MPPageViewController) -> UIView {
        return self.menuView
    }
    
    override func menuViewHeightFor(_ pageController: MPPageViewController) -> CGFloat {
        return 50
    }
    
    override func menuViewPinHeightFor(_ pageController: MPPageViewController) -> CGFloat {
        return 0.0
    }
    
    override func pageController(_ pageController: MPPageViewController, contentScrollViewDidScroll scrollView: UIScrollView) {
        menuView.updateLayout(scrollView)
    }
    
    override func pageController(_ pageController: MPPageViewController, didDisplay viewController: (UIViewController & MPChildViewControllerProtocol), forItemAt index: Int) {
        menuView.checkState(animation: true)
    }
}

extension MPPageStype1ViewController: MPMenuViewDelegate {
    func menuView(_ menuView: MPMenuView, didSelectedItemAt index: Int) {
        guard index < 5 else {
            return
        }
        setSelect(index: index, animation: true)
    }
    
    
}
