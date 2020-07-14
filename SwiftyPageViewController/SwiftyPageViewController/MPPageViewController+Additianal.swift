//
//  MPPageViewController+Additianal.swift
//  SwiftyPageViewController
//
//  Created by Qihe_mac on 2020/7/14.
//  Copyright © 2020 QiHe. All rights reserved.
//

import UIKit

extension MPPageViewController {
    public func updateHeaderViewHeight(animated: Bool = false,
                                       duration: TimeInterval = 0.25,
                                       completion: ((Bool) -> Void)? = nil) {
        
        headerViewHeight = headerViewHeightFor(self)
        sillValue = headerViewHeight - menuViewPinHeight
        
        mainScrollView.headerViewHeight = headerViewHeight
        headerViewConstraint?.constant = headerViewHeight
        
        var manualHandel = false
        if mainScrollView.contentOffset.y < sillValue {
            currentChildScrollView?.contentOffset = currentChildScrollView?.mp_originOffset ?? .zero
            currentChildScrollView?.mp_isCanScroll = false
            mainScrollView.mp_isCanScroll = true
            manualHandel = true
        } else if mainScrollView.contentOffset.y == sillValue  {
            mainScrollView.mp_isCanScroll = false
            manualHandel = true
        }
        let isAdsorption = (headerViewHeight <= 0.0) ? true : !mainScrollView.mp_isCanScroll
        if animated {
            UIView.animate(withDuration: duration, animations: {
                self.mainScrollView.layoutIfNeeded()
                if manualHandel {
                    self.pageController(self, menuView: isAdsorption)
                }
            }) { (finish) in
                completion?(finish)
            }
        } else {
            self.pageController(self, menuView: isAdsorption)
            completion?(true)
        }
    }
    
    public func setSelect(index: Int, animation: Bool) {
        let offset = CGPoint(x: contentScrollView.bounds.width * CGFloat(index),
                             y: contentScrollView.contentOffset.y)
        contentScrollView.setContentOffset(offset, animated: animation)
        if animation == false {
            contentScrollViewDidEndScroll(contentScrollView)
        }
    }
    
    public func reloadData() {
        mainScrollView.isUserInteractionEnabled = false
        clear()
        obtainDataSource()
        updateOriginContent()
        setupDataSource()
        view.layoutIfNeeded()
        if originIndex > 0 {
            setSelect(index: originIndex, animation: false)
        } else {
            showChildViewContoller(at: originIndex)
            didDisplayViewController(at: originIndex)
        }
        mainScrollView.isUserInteractionEnabled = true
    }
}

extension MPPageViewController: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == mainScrollView {
            pageController(self, mainScrollViewDidScroll: scrollView)
            let offsetY = scrollView.contentOffset.y
            if offsetY >= sillValue {
                scrollView.contentOffset = CGPoint(x: 0, y: sillValue)
                currentChildScrollView?.mp_isCanScroll = true
                scrollView.mp_isCanScroll = false
                pageController(self, menuView: !scrollView.mp_isCanScroll)
            } else {
                
                if scrollView.mp_isCanScroll == false {
                    pageController(self, menuView: true)
                    scrollView.contentOffset = CGPoint(x: 0, y: sillValue)
                } else {
                    pageController(self, menuView: false)
                }
            }
        } else {
            pageController(self, contentScrollViewDidScroll: scrollView)
            layoutChildViewControlls()
        }
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == contentScrollView {
            mainScrollView.isScrollEnabled = false
        }
    }

    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == contentScrollView {
            mainScrollView.isScrollEnabled = true
            if decelerate == false {
                contentScrollViewDidEndScroll(contentScrollView)
            }
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == contentScrollView {
            contentScrollViewDidEndScroll(contentScrollView)
        }
    }
    
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if scrollView == contentScrollView {
            contentScrollViewDidEndScroll(contentScrollView)
        }
    }
    
    public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        guard scrollView == mainScrollView else {
            return false
        }
        currentChildScrollView?.setContentOffset(currentChildScrollView?.mp_originOffset ?? .zero, animated: true)
        return true
    }
    
}

extension MPPageViewController {
    internal func childScrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.bounds.width < scrollView.contentSize.width {
            if scrollView.mp_isCanScroll == false {

                scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: 0)
            }
            else {
                let offsetY = scrollView.contentOffset.y
                if offsetY <= (scrollView.mp_originOffset ?? .zero).y {
                    scrollView.contentOffset = scrollView.mp_originOffset ?? .zero
                    scrollView.mp_isCanScroll = false
                    mainScrollView.mp_isCanScroll = true
                }
            }
        }
        else {
            if scrollView.mp_isCanScroll == false {

                scrollView.contentOffset = scrollView.mp_originOffset ?? .zero
            }
            let offsetY = scrollView.contentOffset.y
            if offsetY <= (scrollView.mp_originOffset ?? .zero).y {
                scrollView.contentOffset = scrollView.mp_originOffset ?? .zero
                scrollView.mp_isCanScroll = false
                mainScrollView.mp_isCanScroll = true
            }
        }
        

    }
}

