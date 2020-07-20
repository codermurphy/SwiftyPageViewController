//
//  MPPageViewController.swift
//  SwiftyPageViewController
//
//  Created by Qihe_mac on 2020/7/14.
//  Copyright © 2020 QiHe. All rights reserved.
//

import UIKit

open class MPPageBaseViewController: UIViewController,MPPageControllerDataSource, MPPageControllerDelegate {
    
    // MARK: - menu所在位置
    public enum MenuPosition {
        case normal
        case navigation(position: MenuPostionNavigation,width: CGFloat)
    }
    
    public enum MenuPostionNavigation {
        case left
        case center
        case right
    }

    /// 当前controller
    public private(set) var currentViewController: (UIViewController & MPChildViewControllerProtocol)?
    
    /// 当前所在index
    public private(set) var currentIndex = 0
    internal var originIndex = 0
    
    private var contentScrollViewConstraint: NSLayoutConstraint?
    private var menuViewConstraint: NSLayoutConstraint?
    internal var headerViewConstraint: NSLayoutConstraint?
    private var mainScrollViewConstraints: [NSLayoutConstraint] = []
    
    internal var headerViewHeight: CGFloat = 0.0
    internal lazy var headerContentView = UIView()
    private let menuContentView: MPPageNavigationItemContainer = {
        let menu = MPPageNavigationItemContainer()
        menu.backgroundColor = .clear
        return menu
    }()
    private var menuViewHeight: CGFloat = 0.0
    internal var menuViewPinHeight: CGFloat = 0.0
    internal var sillValue: CGFloat = 0.0
    private var childControllerCount = 0
    private var countArray = [Int]()
    private var containViews = [MPPageContainView]()
    internal var currentChildScrollView: UIScrollView?
    private var childScrollViewObservation: NSKeyValueObservation?
    
    private let memoryCache = NSCache<NSString, UIViewController>()
    private weak var dataSource: MPPageControllerDataSource?
    private weak var delegate: MPPageControllerDelegate?
    
    internal var menuPosition: MenuPosition = .normal
    
    
    open override var shouldAutomaticallyForwardAppearanceMethods: Bool {
        return false
    }

    // MARK: - UI
    lazy public private(set) var mainScrollView: MPPageMainScrollView = {
        let scrollView = MPPageMainScrollView()
        scrollView.delegate = self
        scrollView.mp_isCanScroll = true
        return scrollView
    }()
    
    lazy internal var contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.scrollsToTop = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        if let popGesture = navigationController?.interactivePopGestureRecognizer {
            scrollView.panGestureRecognizer.require(toFail: popGesture)
        }
        return scrollView
    }()
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()


    
    // MARK: - initial methods
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        dataSource = self
        delegate = self
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        dataSource = self
        delegate = self
    }
    
    // MARK: - life cycle
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        switch self.menuPosition {
        case .navigation:
            if self.navigationController == nil { self.menuPosition = . normal }
        default:
            break
        }
        
        
        obtainDataSource()
        setupOriginContent()
        setupDataSource()
        view.layoutIfNeeded()
        if originIndex > 0 {
            setSelect(index: originIndex, animation: false)
        } else {
            showChildViewContoller(at: originIndex)
            didDisplayViewController(at: originIndex)
        }
    }
    
    deinit {
        childScrollViewObservation?.invalidate()
    }
    
    // MARK: - methods
    internal func didDisplayViewController(at index: Int) {
        guard childControllerCount > 0
            , index >= 0
            , index < childControllerCount
            , containViews.isEmpty == false else {
                return
        }
        let containView = containViews[index]
        currentViewController = containView.viewController
        currentChildScrollView = currentViewController?.mp_ChildScrollView()
        currentIndex = index

        childScrollViewObservation?.invalidate()
        let keyValueObservation = currentChildScrollView?.observe(\.contentOffset, options: [.new, .old], changeHandler: { [weak self] (scrollView, change) in
            guard let self = self, change.newValue != change.oldValue else {
                return
            }
            self.childScrollViewDidScroll(scrollView)
        })
        childScrollViewObservation = keyValueObservation

        if let viewController = containView.viewController {
            pageController(self, didDisplay: viewController, forItemAt: index)
        }
    }
    
    
    internal func obtainDataSource() {
        originIndex = originIndexFor(self)
        
        headerViewHeight = headerViewHeightFor(self)
        
        menuViewHeight = menuViewHeightFor(self)
        menuViewPinHeight = menuViewPinHeightFor(self)
        
        childControllerCount = numberOfViewControllers(in: self)
        
        sillValue = headerViewHeight - menuViewPinHeight
        countArray = Array(stride(from: 0, to: childControllerCount, by: 1))
    }
    
    private func setupOriginContent() {
        
        mainScrollView.headerViewHeight = headerViewHeight
        mainScrollView.menuViewHeight = menuViewHeight
        if #available(iOS 13.0, *) {
            mainScrollView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        view.addSubview(mainScrollView)
        let contentInset = contentInsetFor(self)
        let constraints = [
            mainScrollView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: contentInset.top),
            mainScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: contentInset.left),
            mainScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -contentInset.bottom),
            mainScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -contentInset.right)
        ]
        mainScrollViewConstraints = constraints
        NSLayoutConstraint.activate(constraints)
        
        if let _ = headerViewFor(self) {
            mainScrollView.addSubview(headerContentView)
            headerContentView.translatesAutoresizingMaskIntoConstraints = false
            
            let headerContentViewHeight = headerContentView.heightAnchor.constraint(equalToConstant: headerViewHeight)
            headerContentViewHeight.priority = .defaultHigh
            
            let headerContentViewTop = headerContentView.topAnchor.constraint(equalTo: mainScrollView.topAnchor)
            headerContentViewTop.priority = .defaultHigh
            
            headerViewConstraint = headerContentViewHeight
            NSLayoutConstraint.activate([
                headerContentView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
                headerContentView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor),
                headerContentViewTop,
                headerContentViewHeight,
            ])
        }

        
        switch self.menuPosition {
        case .normal:
            mainScrollView.addSubview(menuContentView)
            menuContentView.translatesAutoresizingMaskIntoConstraints = false
            
            let menuContentViewHeight = menuContentView.heightAnchor.constraint(equalToConstant: menuViewHeight)
            menuViewConstraint = menuContentViewHeight
            NSLayoutConstraint.activate([
                menuContentView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
                menuContentView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor),
                menuContentView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor),
                menuContentView.topAnchor.constraint(equalTo: headerViewFor(self) ==  nil ? mainScrollView.topAnchor :headerContentView.bottomAnchor),
                menuContentViewHeight
            ])
        case let .navigation(position, width):
            menuContentView.frame.size = CGSize(width: width, height: 44)
            switch position {
            case .center:
                self.navigationItem.titleView = menuContentView
            case .left:
                self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: menuContentView)
            case .right:
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: menuContentView)
            }
            break
        }

        
        mainScrollView.addSubview(contentScrollView)
        
        let contentScrollViewHeight = contentScrollView.heightAnchor.constraint(equalTo: mainScrollView.heightAnchor, constant: -menuViewHeight - menuViewPinHeight)
        contentScrollViewConstraint = contentScrollViewHeight
        
        switch self.menuPosition {
        case .normal:
            NSLayoutConstraint.activate([
                contentScrollView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
                contentScrollView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor),
                contentScrollView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor),
                contentScrollView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor),
                contentScrollView.topAnchor.constraint(equalTo: menuContentView.bottomAnchor),
                contentScrollViewHeight
                ])
        case .navigation:
            NSLayoutConstraint.activate([
                contentScrollView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
                contentScrollView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor),
                contentScrollView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor),
                contentScrollView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor),
                contentScrollView.topAnchor.constraint(equalTo: mainScrollView.topAnchor),
                contentScrollViewHeight
                ])
        }
        

        
        
        contentScrollView.addSubview(contentStackView)
        
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: contentScrollView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: contentScrollView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: contentScrollView.bottomAnchor),
            contentStackView.topAnchor.constraint(equalTo: contentScrollView.topAnchor),
            contentStackView.heightAnchor.constraint(equalTo: contentScrollView.heightAnchor)
        ])
        
        switch self.menuPosition {
        case .normal:
            mainScrollView.bringSubviewToFront(menuContentView)
            mainScrollView.bringSubviewToFront(headerContentView)
        case .navigation:
            break
        }
        

    }
    
    internal func updateOriginContent() {
        mainScrollView.headerViewHeight = headerViewHeight
        mainScrollView.menuViewHeight = menuViewHeight
        
        if mainScrollViewConstraints.count == 4 {
            let contentInset = contentInsetFor(self)
            mainScrollViewConstraints.first?.constant = contentInset.top
            mainScrollViewConstraints[1].constant = contentInset.left
            mainScrollViewConstraints[2].constant = -contentInset.bottom
            mainScrollViewConstraints.last?.constant = -contentInset.right
        }
        headerViewConstraint?.constant = headerViewHeight
        menuViewConstraint?.constant = menuViewHeight
        contentScrollViewConstraint?.constant = -menuViewHeight - menuViewPinHeight
    }
    
    internal func clear() {
        childScrollViewObservation?.invalidate()
        
        originIndex = 0
        
        mainScrollView.mp_isCanScroll = true
        currentChildScrollView?.mp_isCanScroll = false
        
        childControllerCount = 0
        
        currentViewController = nil
        currentChildScrollView?.mp_originOffset = nil
        currentChildScrollView = nil
        
        menuContentView.subviews.forEach({$0.removeFromSuperview()})
        headerContentView.subviews.forEach({$0.removeFromSuperview()})
        contentScrollView.contentOffset = .zero
        
        contentStackView.arrangedSubviews.forEach({$0.removeFromSuperview()})
        clearMemoryCache()
        
        containViews.forEach({$0.viewController?.mp_clearFromParent()})
        containViews.removeAll()
        
        countArray.removeAll()
    }
    
    internal func clearMemoryCache() {
        countArray.forEach { (index) in
            let viewController = memoryCache[index] as? (UIViewController & MPChildViewControllerProtocol)
            let scrollView = viewController?.mp_ChildScrollView()
            scrollView?.mp_originOffset = nil
        }
        memoryCache.removeAllObjects()
    }
    
    internal func setupDataSource() {

        memoryCache.countLimit = childControllerCount
        
        if let headerView = headerViewFor(self)  {
            headerContentView.addSubview(headerView)
            headerView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                headerView.leadingAnchor.constraint(equalTo: headerContentView.leadingAnchor),
                headerView.trailingAnchor.constraint(equalTo: headerContentView.trailingAnchor),
                headerView.bottomAnchor.constraint(equalTo: headerContentView.bottomAnchor),
                headerView.topAnchor.constraint(equalTo: headerContentView.topAnchor)
                ])
        }
        else {
            currentViewController?.mp_ChildScrollView().mp_isCanScroll = true
        }
        


        
        let menuView = menuViewFor(self)
        menuContentView.addSubview(menuView)
        menuView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            menuView.leadingAnchor.constraint(equalTo: menuContentView.leadingAnchor),
            menuView.trailingAnchor.constraint(equalTo: menuContentView.trailingAnchor),
            menuView.bottomAnchor.constraint(equalTo: menuContentView.bottomAnchor),
            menuView.topAnchor.constraint(equalTo: menuContentView.topAnchor)
            ])
        
        
        countArray.forEach { (_) in
            let containView = MPPageContainView()
            contentStackView.addArrangedSubview(containView)
            NSLayoutConstraint.activate([
                containView.heightAnchor.constraint(equalTo: contentScrollView.heightAnchor),
                containView.widthAnchor.constraint(equalTo: contentScrollView.widthAnchor)
                ])
            containViews.append(containView)
        }
    }
    
    internal func showChildViewContoller(at index: Int) {
        guard childControllerCount > 0
            , index >= 0
            , index < childControllerCount
            , containViews.isEmpty == false else {
            return
        }
        
        let containView = containViews[index]
        guard containView.isEmpty else {
            return
        }
        
        let cachedViewContoller = memoryCache[index] as? (UIViewController & MPChildViewControllerProtocol)
        let viewController = cachedViewContoller != nil ? cachedViewContoller : pageController(self, viewControllerAt: index)
        
        guard let targetViewController = viewController else {
            return
        }
        pageController(self, willDisplay: targetViewController, forItemAt: index)
        
        addChild(targetViewController)
        targetViewController.beginAppearanceTransition(true, animated: false)
        containView.addSubview(targetViewController.view)
        targetViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            targetViewController.view.leadingAnchor.constraint(equalTo: containView.leadingAnchor),
            targetViewController.view.trailingAnchor.constraint(equalTo: containView.trailingAnchor),
            targetViewController.view.bottomAnchor.constraint(equalTo: containView.bottomAnchor),
            targetViewController.view.topAnchor.constraint(equalTo: containView.topAnchor),
            ])
        targetViewController.endAppearanceTransition()
        targetViewController.didMove(toParent: self)
        targetViewController.view.layoutSubviews()
        containView.viewController = targetViewController
        
        let scrollView = targetViewController.mp_ChildScrollView()
        scrollView.mp_originOffset = scrollView.contentOffset
    
        if let _ = headerViewFor(self) {
            if mainScrollView.contentOffset.y < sillValue {
                scrollView.contentOffset = scrollView.mp_originOffset ?? .zero
                scrollView.mp_isCanScroll = false
                mainScrollView.mp_isCanScroll = true
            }
        }
        else {
            scrollView.mp_isCanScroll = true
        }

    }
    
    
    private func removeChildViewController(at index: Int) {
        guard childControllerCount > 0
            , index >= 0
            , index < childControllerCount
            , containViews.isEmpty == false else {
                return
        }
        
        let containView = containViews[index]
        guard containView.isEmpty == false
            , let viewController = containView.viewController else {
            return
        }
        viewController.mp_clearFromParent()
        if memoryCache[index] == nil {
            pageController(self, willCache: viewController, forItemAt: index)
            memoryCache[index] = viewController
        }
    }
      
    internal func layoutChildViewControlls() {
        countArray.forEach { (index) in
            let containView = containViews[index]
            let isDisplayingInScreen = containView.displayingIn(view: view, containView: contentScrollView)
            isDisplayingInScreen ? showChildViewContoller(at: index) : removeChildViewController(at: index)
        }
    }
    
    internal func contentScrollViewDidEndScroll(_ scrollView: UIScrollView) {
        let scrollViewWidth = scrollView.bounds.width
        guard scrollViewWidth > 0 else {
            return
        }
        
        let offsetX = scrollView.contentOffset.x
        let index = Int(offsetX / scrollViewWidth)
        didDisplayViewController(at: index)
        pageController(self, contentScrollViewDidEndScroll: contentScrollView)
    }
    
    
    open func pageController(_ pageController: MPPageBaseViewController, viewControllerAt index: Int) -> (UIViewController & MPChildViewControllerProtocol) {
        assertionFailure("Sub-class must implement the AMPageControllerDataSource method")
        return UIViewController() as! (UIViewController & MPChildViewControllerProtocol)
    }
    
    open func numberOfViewControllers(in pageController: MPPageBaseViewController) -> Int {
        assertionFailure("Sub-class must implement the AMPageControllerDataSource method")
        return 0
    }
    
    open func headerViewFor(_ pageController: MPPageBaseViewController) -> UIView? {
        assertionFailure("Sub-class must implement the AMPageControllerDataSource method")
        return nil
    }
    
    open func headerViewHeightFor(_ pageController: MPPageBaseViewController) -> CGFloat {
        assertionFailure("Sub-class must implement the AMPageControllerDataSource method")
        return 0
    }
    
    open func menuViewFor(_ pageController: MPPageBaseViewController) -> UIView {
        assertionFailure("Sub-class must implement the AMPageControllerDataSource method")
        return UIView()
    }
    
    open func menuViewHeightFor(_ pageController: MPPageBaseViewController) -> CGFloat {
        assertionFailure("Sub-class must implement the AMPageControllerDataSource method")
        return 0
    }
    
    open func originIndexFor(_ pageController: MPPageBaseViewController) -> Int {
        return 0
    }
    
    open func menuViewPinHeightFor(_ pageController: MPPageBaseViewController) -> CGFloat {
        return 0
    }
    
    open func pageController(_ pageController: MPPageBaseViewController, mainScrollViewDidScroll scrollView: UIScrollView) {
        
    }
    
    open func pageController(_ pageController: MPPageBaseViewController, contentScrollViewDidEndScroll scrollView: UIScrollView) {
        
    }
    
    open func pageController(_ pageController: MPPageBaseViewController, contentScrollViewDidScroll scrollView: UIScrollView) {
        
    }
    
    open func pageController(_ pageController: MPPageBaseViewController, willCache viewController: (UIViewController & MPChildViewControllerProtocol), forItemAt index: Int) {
        
    }
    
    open func pageController(_ pageController: MPPageBaseViewController, willDisplay viewController: (UIViewController & MPChildViewControllerProtocol), forItemAt index: Int) {
        
    }
    
    open func pageController(_ pageController: MPPageBaseViewController, didDisplay viewController: (UIViewController & MPChildViewControllerProtocol), forItemAt index: Int) {
        
    }
    
    open func pageController(_ pageController: MPPageBaseViewController, menuView isAdsorption: Bool) {
        
    }
    
    open func contentInsetFor(_ pageController: MPPageBaseViewController) -> UIEdgeInsets {
        return .zero
    }

}
