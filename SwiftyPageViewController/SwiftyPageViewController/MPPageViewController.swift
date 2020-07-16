//
//  MPPageViewController.swift
//  SwiftyPageViewController
//
//  Created by Qihe_mac on 2020/7/16.
//  Copyright © 2020 QiHe. All rights reserved.
//

import UIKit

public enum MPMenuRefreshPosition {
    
    case headerTop /// 当有headerView时
    case menuBottom
    
}

public class MPPageViewController: MPPageBaseViewController {
    
    // MARK: - initial methods
    public init(configs: [MPMenuStyle],
                menuContents: [MPMenuModel],
                controllers: [UIViewController & MPChildViewControllerProtocol],
                headerView: UIView? = nil,
                menuViewHeight: CGFloat,
                defaultMenuPinHeight: CGFloat,
                defaultIndex: Int = 0) {
        self.configs = configs
        self.menuContents = menuContents
        self.controllers = controllers
        self.headerView = headerView
        self.menuViewHeight = menuViewHeight
        self.defaultMenuPinHeight = defaultMenuPinHeight
        self.defaultIndex = defaultIndex
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.\
        
        self.menuView.titles = self.menuContents
    }
    
    // MARK: - property
    private var menuContents: [MPMenuModel]
    
    private var configs: [MPMenuStyle]
    
    private var controllers: [UIViewController & MPChildViewControllerProtocol]
    
    private var headerView: UIView?
    
    private var menuViewHeight: CGFloat = 0
    
    private var defaultMenuPinHeight: CGFloat = 0
    
    private var defaultIndex: Int = 0
    
    private var refreshPosition: MPMenuRefreshPosition = .menuBottom
    
    private lazy var menuView: MPMenuView = {
        let menu = MPMenuView(parts: self.configs)
        if let popGesture = navigationController?.interactivePopGestureRecognizer {
            menu.scrollView.panGestureRecognizer.require(toFail: popGesture)
        }
        menu.delegate = self
        return menu
    }()
        

    
    // MARK: - override delegate and datasource
    
    public override func pageController(_ pageController: MPPageBaseViewController, viewControllerAt index: Int) -> (UIViewController & MPChildViewControllerProtocol) {
        return self.controllers[index]
    }
    
    public override func numberOfViewControllers(in pageController: MPPageBaseViewController) -> Int {
        return self.controllers.count
    }
    
    public override func headerViewFor(_ pageController: MPPageBaseViewController) -> UIView? {
        return self.headerView
    }
    
    public override func headerViewHeightFor(_ pageController: MPPageBaseViewController) -> CGFloat {
        return self.headerView?.frame.height ?? 0
    }
    
    public override func menuViewFor(_ pageController: MPPageBaseViewController) -> UIView {
        return self.menuView
    }
    
    public override func menuViewHeightFor(_ pageController: MPPageBaseViewController) -> CGFloat {
        return self.menuViewHeight
    }
    
    public override func originIndexFor(_ pageController: MPPageBaseViewController) -> Int {
        return self.defaultIndex
    }
    
    public override func menuViewPinHeightFor(_ pageController: MPPageBaseViewController) -> CGFloat {
        switch self.refreshPosition {
        case .headerTop:
            return 0
        case .menuBottom:
            return self.headerView?.frame.height ?? 0
            
        }
    }
    
    public override func pageController(_ pageController: MPPageBaseViewController, mainScrollViewDidScroll scrollView: UIScrollView) {
        
    }
    
    public override func pageController(_ pageController: MPPageBaseViewController, contentScrollViewDidEndScroll scrollView: UIScrollView) {
        
    }
    
    public override func pageController(_ pageController: MPPageBaseViewController, contentScrollViewDidScroll scrollView: UIScrollView) {
        self.menuView.updateLayout(scrollView)
    }
    
    public override func pageController(_ pageController: MPPageBaseViewController, willCache viewController: (UIViewController & MPChildViewControllerProtocol), forItemAt index: Int) {
        
    }
    
    public override func pageController(_ pageController: MPPageBaseViewController, willDisplay viewController: (UIViewController & MPChildViewControllerProtocol), forItemAt index: Int) {
        
    }
    
    public override func pageController(_ pageController: MPPageBaseViewController, didDisplay viewController: (UIViewController & MPChildViewControllerProtocol), forItemAt index: Int) {
        self.menuView.checkState(animation: true)
    }
    
    public override func pageController(_ pageController: MPPageBaseViewController, menuView isAdsorption: Bool) {
        
    }
    
    public override func contentInsetFor(_ pageController: MPPageBaseViewController) -> UIEdgeInsets {
        return .zero
    }
}

extension MPPageViewController: MPMenuViewDelegate {
   public func menuView(_ menuView: MPMenuView, didSelectedItemAt index: Int) {
    guard index < self.menuContents.count else {
            return
        }
        setSelect(index: index, animation: true)
    }
    
    
}
