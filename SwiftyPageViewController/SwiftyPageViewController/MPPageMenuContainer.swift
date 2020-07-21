//
//  MPPageNavigationItemContainer.swift
//  SwiftyPageViewController
//
//  Created by Qihe_mac on 2020/7/20.
//  Copyright © 2020 QiHe. All rights reserved.
//

import UIKit

class MPPageMenuContainer: UIView {
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: self.bounds.width, height: UIView.layoutFittingExpandedSize.height)
    }
    
    deinit {
        debugPrint(Self.self)
    }
}
