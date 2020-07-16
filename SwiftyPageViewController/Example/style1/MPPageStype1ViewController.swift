//
//  MPPageStype1ViewController.swift
//  SwiftyPageViewController
//
//  Created by Qihe_mac on 2020/7/15.
//  Copyright © 2020 QiHe. All rights reserved.
//

import UIKit

class MPPageStype1ViewController: MPPageBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.menuView.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)

        self.menuView.titles = [MPMenuModel(title: "page1"),MPMenuModel(title: "page2"),MPMenuModel(title: "page3"),MPMenuModel(title: "page4"),MPMenuModel(title: "page5")]
    }
    

    // MARK: - UI
    lazy var menuView: MPMenuView = {
        let view = MPMenuView(parts:
            [.normalTextColor(UIColor.gray),
            .selectedTextColor(UIColor.blue),
            .normalTextFont(UIFont.systemFont(ofSize: 15.0)),
            .selectedTextFont(UIFont.systemFont(ofSize: 15.0)),
            .switchStyle(.line),
            .itemSpace(30),
            .indicatorStyle(
                MPIndicatorViewStyle(parts:
                    .backgroundColor(.brown),
                    .height(3.0),
                    .position(.contentBottom(offset: 0)),
                    .extraWidth(0),
                    .shape(.line(isAutoWidth: false, width: 15))
                )
            ),
            .bottomLineStyle(
                MPBottomLineViewStyle(parts:
                    .hidden(false)
                )
            ),
            .layoutStyle(.auto)]
        )
        view.delegate = self
        return view
    }()
    
    
    // MARK: - override methods
    
    override func pageController(_ pageController: MPPageBaseViewController, viewControllerAt index: Int) -> (UIViewController & MPChildViewControllerProtocol) {
        
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
    
    override func numberOfViewControllers(in pageController: MPPageBaseViewController) -> Int {
        return 5
    }
    
    override func headerViewFor(_ pageController: MPPageBaseViewController) -> UIView? {
        return nil
    }
    
    override func headerViewHeightFor(_ pageController: MPPageBaseViewController) -> CGFloat {
        return 0
    }
    
    override func menuViewFor(_ pageController: MPPageBaseViewController) -> UIView {
        return self.menuView
    }
    
    override func menuViewHeightFor(_ pageController: MPPageBaseViewController) -> CGFloat {
        return 50
    }
    
    override func menuViewPinHeightFor(_ pageController: MPPageBaseViewController) -> CGFloat {
        return 0.0
    }
    
    override func pageController(_ pageController: MPPageBaseViewController, contentScrollViewDidScroll scrollView: UIScrollView) {
        menuView.updateLayout(scrollView)
    }
    
    override func pageController(_ pageController: MPPageBaseViewController, didDisplay viewController: (UIViewController & MPChildViewControllerProtocol), forItemAt index: Int) {
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
