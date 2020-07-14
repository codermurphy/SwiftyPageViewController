//
//  MPPageContainView.swift
//  SwiftyPageViewController
//
//  Created by Qihe_mac on 2020/7/14.
//  Copyright © 2020 QiHe. All rights reserved.
//

import UIKit

class MPPageContainView: UIView {

    weak var viewController: (UIViewController & MPChildViewControllerProtocol)?
    var isEmpty: Bool {
        return subviews.isEmpty
    }
    
    func displayingIn(view: UIView, containView: UIView) -> Bool {
        let convertedFrame = containView.convert(frame, to: view)
        return view.frame.intersects(convertedFrame)
    }

}
