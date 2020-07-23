//
//  MPPageViewController+Additianal.swift
//  SwiftyPageViewController
//
//  Created by Qihe_mac on 2020/7/14.
//  Copyright © 2020 QiHe. All rights reserved.
//


import UIKit

extension MPPageViewController {
    
    public override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == mainScrollView {
            pageController(self, mainScrollViewDidScroll: scrollView)
            let offsetY = scrollView.contentOffset.y
            if let _ = headerViewFor(self) {
                if offsetY >= sillValue {
                    scrollView.contentOffset = CGPoint(x: 0, y: sillValue)
                    currentChildScrollView?.mp_isCanScroll = true
                    scrollView.mp_isCanScroll = false
                    pageController(self, menuView: !scrollView.mp_isCanScroll)
                } else {
                    if self.refreshPosition == .headerTop {
                        if scrollView.mp_isCanScroll == false {
                            pageController(self, menuView: true)
                            if let canScroll = currentChildScrollView?.mp_isCanScroll,canScroll == true {
                                 scrollView.contentOffset = CGPoint(x: 0, y: sillValue)
                            }
                        } else {
                            pageController(self, menuView: false)
                        }
                    }
                    else {

                        if offsetY <= 0 {
                            if let currentChildOffSetY = currentChildScrollView?.contentOffset.y,currentChildOffSetY <= 0 {
                                scrollView.contentOffset = CGPoint(x: 0, y: 0)
                                currentChildScrollView?.mp_isCanScroll = true
                                scrollView.mp_isCanScroll = false
                            }
                            else {
                                scrollView.contentOffset = CGPoint(x: 0, y: sillValue)
                                currentChildScrollView?.mp_isCanScroll = true
                                scrollView.mp_isCanScroll = false
                            }

                        }
                        else {
                            if offsetY >= sillValue {
                                scrollView.contentOffset = CGPoint(x: 0, y: sillValue)
                                currentChildScrollView?.mp_isCanScroll = true
                                scrollView.mp_isCanScroll = false
                            }
                            else {
                                if scrollView.mp_isCanScroll == false {
                                    pageController(self, menuView: true)
                                    if let canScroll = currentChildScrollView,canScroll.mp_isCanScroll == true, canScroll.contentOffset.y > 0{
                                         scrollView.contentOffset = CGPoint(x: 0, y: sillValue)
                                    }
                                    else {
                                        currentChildScrollView?.contentOffset = .zero
                                    }
                                } else {
                                    pageController(self, menuView: false)
                                }
                            }
                        }
                    }
                }
            }
            else {
                if offsetY >= 0 {
                    scrollView.contentOffset = CGPoint(x: 0, y: 0)
                    currentChildScrollView?.mp_isCanScroll = true
                    scrollView.mp_isCanScroll = false
                }
                else {

                    if scrollView.mp_isCanScroll == false {
                        pageController(self, menuView: true)
                        if let canScroll = currentChildScrollView?.mp_isCanScroll,canScroll == true {
                             scrollView.contentOffset = CGPoint(x: 0, y: sillValue)
                        }
                    } else {
                        pageController(self, menuView: false)
                    }
                }
            }
        } else {
            pageController(self, contentScrollViewDidScroll: scrollView)
            layoutChildViewControlls()
        }
    }
    
    public override func childScrollViewDidScroll(_ scrollView: UIScrollView) {
        
        switch self.menuPosition {
        case .bottom,.navigation:
            break
        case .normal:
            if let _ = headerViewFor(self) {
                if self.refreshPosition == .headerTop {
                    if scrollView.mp_isCanScroll == false {

                        scrollView.contentOffset = scrollView.mp_originOffset ?? CGPoint(x: scrollView.contentOffset.x, y: 0)
                    }
                    let offsetY = scrollView.contentOffset.y
                    if offsetY <= (scrollView.mp_originOffset ?? .zero).y {
                        scrollView.contentOffset = scrollView.mp_originOffset ?? CGPoint(x: scrollView.contentOffset.x, y: 0)
                        scrollView.mp_isCanScroll = false
                        mainScrollView.mp_isCanScroll = true
                    }
                }
                else {
                    if scrollView.contentOffset.y <= 0 {
                        if !self.isFixedHeaderView {
                            

                            scrollView.mp_isCanScroll = true
                            mainScrollView.mp_isCanScroll = false
                        }
                        else {
                            scrollView.mp_isCanScroll = false
                            mainScrollView.mp_isCanScroll = true
                        }

                    }
                    else {
                        if mainScrollView.contentOffset.y < sillValue {
                            mainScrollView.mp_isCanScroll = true
                            scrollView.mp_isCanScroll = false
                        }
                        else {
                            mainScrollView.mp_isCanScroll = false
                            scrollView.mp_isCanScroll = true
                        }
                        
                        if scrollView.mp_isCanScroll == false {

                            scrollView.contentOffset = scrollView.mp_originOffset ?? CGPoint(x: scrollView.contentOffset.x, y: 0)
                        }
                        let offsetY = scrollView.contentOffset.y
                        if offsetY <= (scrollView.mp_originOffset ?? .zero).y {
                            scrollView.contentOffset = scrollView.mp_originOffset ?? CGPoint(x: scrollView.contentOffset.x, y: 0)
                            scrollView.mp_isCanScroll = false
                            mainScrollView.mp_isCanScroll = true
                        }
                    }
                }
            }
            else {
                if self.refreshPosition == .menuTop {
                    if mainScrollView.mp_isCanScroll {
                        scrollView.contentOffset = scrollView.mp_originOffset ?? CGPoint(x: scrollView.contentOffset.x, y: 0)
                        scrollView.mp_isCanScroll = false
                    }
                    else {
                        scrollView.mp_isCanScroll = true
                        if scrollView.contentOffset.y <= 0 {
                            mainScrollView.mp_isCanScroll = true
                            scrollView.mp_isCanScroll = false
                        }
                    }
                }
            }
        }
        
    }
}

