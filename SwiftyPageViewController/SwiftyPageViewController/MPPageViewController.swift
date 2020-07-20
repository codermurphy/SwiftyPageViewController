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
    case menuTop
    case menuBottom
    
}

public class MPPageViewController: MPPageBaseViewController {
    
    // MARK: - initial methods
    public init(configs: [MPMenuStyle],
                menuContents: [MPMenuModel],
                controllers: [UIViewController & MPChildViewControllerProtocol],
                headerView: UIView? = nil,
                isFixedHeaderView: Bool = false,
                isZooomHeaderView: Bool = false,
                refreshPosition: MPMenuRefreshPosition = .menuBottom,
                menuViewHeight: CGFloat,
                menuExtraView: UIView? = nil,
                menuExtraPoistion: MPMenuExtraViewPostion = .right(width: 40),
                menuPoision: MenuPosition = .normal,
                defaultMenuPinHeight: CGFloat = 0,
                defaultIndex: Int = 0) {
        self.configs = configs
        self.menuContents = menuContents
        self.controllers = controllers
        self.headerView = headerView
        self.defaultHeaderHeight = headerView?.frame.height ?? 0
        self.isFixedHeaderView = headerView == nil ? false : isFixedHeaderView
        self.isZoomHeaderView = headerView == nil ? false : isZooomHeaderView
        self.defaultMenuPinHeight = defaultMenuPinHeight
        self.menuViewHeight = menuViewHeight
        self.defaultIndex = defaultIndex
        self.refreshPosition = refreshPosition
        self.menuExtraView = menuExtraView
        self.menuExtraPosition = menuExtraPoistion
        super.init(nibName: nil, bundle: nil)
        
        self.menuPosition = menuPoision

        
        if headerView == nil {
            if refreshPosition == .headerTop { self.refreshPosition = .menuTop}
            switch self.refreshPosition {
            case .menuBottom:
                self.mainScrollView.alwaysBounceVertical = false
            case .menuTop:
                self.mainScrollView.alwaysBounceVertical = true
            default:
                break
            }
        }
        else {
            if refreshPosition == .menuTop { self.refreshPosition = .headerTop}
            if isZoomHeaderView { self.refreshPosition = .headerTop}
            switch self.refreshPosition {
            case .menuBottom:
                if isFixedHeaderView {
                    self.mainScrollView.alwaysBounceVertical = true
                }
                else {
                    self.mainScrollView.alwaysBounceVertical = false
                }
                self.mainScrollView.alwaysBounceVertical = false
            case .headerTop:
                self.mainScrollView.alwaysBounceVertical = true
            default:
                break
            }
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - life cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.menuView.titles = self.menuContents
        
        self.currentChildScrollView?.mp_isCanScroll = true
        
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
        
    // MARK: - property
    
    /// 菜单内容
    private var menuContents: [MPMenuModel]
    
    /// 菜单配置
    private var configs: [MPMenuStyle]
    
    /// 子控制器
    private var controllers: [UIViewController & MPChildViewControllerProtocol]
    
    /// 头部
    private var headerView: UIView?
    
    /// 菜单额外View
    private var menuExtraView: UIView?
    
    /// 菜单额外宽度
    private var menuExtraPosition: MPMenuExtraViewPostion = .right(width: 40)
    
    /// 菜单高度
    private var menuViewHeight: CGFloat = 0
    
    /// 菜单固定的距离（距离顶部）
    private var defaultMenuPinHeight: CGFloat = 0
    
    /// 默认选择菜单index
    private var defaultIndex: Int = 0
    
    /// 是否固定头部
    private(set) var isFixedHeaderView: Bool = false
    
    /// 刷新控件的位置
    private(set) var refreshPosition: MPMenuRefreshPosition = .menuBottom
    
    /// 是否放大头部
    private(set) var isZoomHeaderView: Bool = false
    
    /// headerView高度
    private var defaultHeaderHeight: CGFloat = 0
     
    // MARK: - UI
    private(set) lazy var menuView: MPMenuView = {
        let menu = MPMenuView(parts: self.configs,extraView: self.menuExtraView,extraPosition: self.menuExtraPosition)
        if let popGesture = navigationController?.interactivePopGestureRecognizer {
            menu.scrollView.panGestureRecognizer.require(toFail: popGesture)
        }
        menu.delegate = self
        return menu
    }()
        

    private func zoomHeaderView(offSetY: CGFloat) {
        if let _ = self.headerView {
            if self.isZoomHeaderView {
                if offSetY < 0 {
                    self.headerContentView.translatesAutoresizingMaskIntoConstraints = true
                    var headViewFrame = self.headerContentView.frame
                    let maxY = headViewFrame.maxY
                    headViewFrame.size.height = 120 - offSetY
                    headViewFrame.origin.y = maxY - headViewFrame.size.height
                    self.headerContentView.frame = headViewFrame
                }
                else {
                    self.headerContentView.translatesAutoresizingMaskIntoConstraints = false
                }
            }
        }
    }
    
    // MARK: - override delegate and datasource
    
    public override func pageController(_ pageController: MPPageBaseViewController, viewControllerAt index: Int) -> (UIViewController & MPChildViewControllerProtocol) {
        return self.controllers[index]
    }
    
    public override func numberOfViewControllers(in pageController: MPPageBaseViewController) -> Int {
        return self.controllers.count
    }
    
    public override func headerViewFor(_ pageController: MPPageBaseViewController) -> UIView? {
        switch self.menuPosition {
        case .normal:
            return self.headerView
        case .navigation:
            return nil
        }
    }
    
    public override func headerViewHeightFor(_ pageController: MPPageBaseViewController) -> CGFloat {
        switch self.menuPosition {
        case .normal:
             return self.defaultHeaderHeight
        case .navigation:
            return 0
        }
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
        if self.isFixedHeaderView {
            if let headerView = self.headerView {
                return headerView.frame.height
            }
            else {
                return self.defaultMenuPinHeight
            }
        }
        else {
            return self.defaultMenuPinHeight
        }
    }
    
    public override func pageController(_ pageController: MPPageBaseViewController, mainScrollViewDidScroll scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= 0 { self.zoomHeaderView(offSetY: scrollView.contentOffset.y) }
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
