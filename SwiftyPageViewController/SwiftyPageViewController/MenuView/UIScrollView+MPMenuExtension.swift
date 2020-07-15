//
//  UIScrollView+MPMenuExtension.swift
//  SwiftyPageViewController
//
//  Created by Qihe_mac on 2020/7/15.
//  Copyright © 2020 QiHe. All rights reserved.
//

import Foundation
import UIKit

extension UIScrollView {
    func scrollToSuitablePosition(_ targetView: UIView?, _ animation: Bool) {
        guard contentSize.width > bounds.width, let targetView = targetView else {
            return
        }
        let x = min(max(targetView.center.x - frame.midX, 0.0), contentSize.width - bounds.width)
        setContentOffset(CGPoint(x: x, y: 0), animated: animation)
    }
}
