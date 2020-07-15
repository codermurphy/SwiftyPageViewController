//
//  MPPageViewControllerProtocol.swift
//  SwiftyPageViewController
//
//  Created by Qihe_mac on 2020/7/14.
//  Copyright © 2020 QiHe. All rights reserved.
//

import UIKit

protocol MPPageControllerDataSource: class {
    
    func pageController(_ pageController: MPPageViewController, viewControllerAt index: Int) -> (UIViewController & MPChildViewControllerProtocol)
    func numberOfViewControllers(in pageController: MPPageViewController) -> Int
    func headerViewFor(_ pageController: MPPageViewController) -> UIView?
    func headerViewHeightFor(_ pageController: MPPageViewController) -> CGFloat
    func menuViewFor(_ pageController: MPPageViewController) -> UIView
    func menuViewHeightFor(_ pageController: MPPageViewController) -> CGFloat
    func menuViewPinHeightFor(_ pageController: MPPageViewController) -> CGFloat
    
    /// The index of the controller displayed by default. You should have menview ready before setting this value
    ///
    /// - Parameter pageController: AquamanPageViewController
    /// - Returns: Int
    func originIndexFor(_ pageController: MPPageViewController) -> Int
}

protocol MPPageControllerDelegate: class {
    
    /// Any offset changes in pageController's mainScrollView
     ///
     /// - Parameters:
     ///   - pageController: AquamanPageViewController
     ///   - scrollView: mainScrollView
     func pageController(_ pageController: MPPageViewController, mainScrollViewDidScroll scrollView: UIScrollView)
    
     
     /// Method call when contentScrollView did end scroll
     ///
     /// - Parameters:
     ///   - pageController: AquamanPageViewController
     ///   - scrollView: contentScrollView
     func pageController(_ pageController: MPPageViewController, contentScrollViewDidEndScroll scrollView: UIScrollView)
     
     
     /// Any offset changes in pageController's contentScrollView
     ///
     /// - Parameters:
     ///   - pageController: AquamanPageViewController
     ///   - scrollView: contentScrollView
     func pageController(_ pageController: MPPageViewController, contentScrollViewDidScroll scrollView: UIScrollView)
     
     /// Method call when viewController will cache
     ///
     /// - Parameters:
     ///   - pageController: AquamanPageViewController
     ///   - viewController: target viewController
     ///   - index: target viewController's index
     func pageController(_ pageController: MPPageViewController, willCache viewController: (UIViewController & MPChildViewControllerProtocol), forItemAt index: Int)
     
     
     /// Method call when viewController will display
     ///
     /// - Parameters:
     ///   - pageController: AquamanPageViewController
     ///   - viewController: target viewController
     ///   - index: target viewController's index
     func pageController(_ pageController: MPPageViewController, willDisplay viewController: (UIViewController & MPChildViewControllerProtocol), forItemAt index: Int)
     
     
     /// Method call when viewController did display
     ///
     /// - Parameters:
     ///   - pageController: AquamanPageViewController
     ///   - viewController: target viewController
     ///   - index: target viewController's index
     func pageController(_ pageController: MPPageViewController, didDisplay viewController: (UIViewController & MPChildViewControllerProtocol), forItemAt index: Int)
     
     
     /// Method call when menuView is adsorption
     ///
     /// - Parameters:
     ///   - pageController: AquamanPageViewController
     ///   - isAdsorption: is adsorption
     func pageController(_ pageController: MPPageViewController, menuView isAdsorption: Bool)
     
     
     /// Asks the delegate for the margins to apply to content.
     /// - Parameter pageController: AquamanPageViewController
     func contentInsetFor(_ pageController: MPPageViewController) -> UIEdgeInsets

}
