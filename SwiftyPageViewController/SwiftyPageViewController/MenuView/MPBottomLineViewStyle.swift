//
//  MPBottomLineViewStyle.swift
//  SwiftyPageViewController
//
//  Created by Qihe_mac on 2020/7/14.
//  Copyright © 2020 QiHe. All rights reserved.
//

import Foundation
import UIKit

public enum MPBottomLineStyle {
    case backgroundColor(UIColor)
    case height(CGFloat)
    case hidden(Bool)
}


public class MPBottomLineViewStyle {
    
    public var backgroundColor = UIColor.black.withAlphaComponent(0.15) {
        didSet {
            targetView?.backgroundColor = backgroundColor
        }
    }
    
    public var height: CGFloat = 0.5 {
        didSet {
            targetView?.snp.updateConstraints({$0.height.equalTo(height)})
        }
    }
    
    public var hidden = false {
        didSet {
            targetView?.isHidden = hidden
        }
    }
    
    weak var targetView: UIView? {
        didSet {
            targetView?.backgroundColor = backgroundColor
            targetView?.snp.updateConstraints({$0.height.equalTo(height)})
            targetView?.isHidden = hidden
        }
    }
    
    public init(view: UIView) {
        targetView = view
    }
    
    public init(parts: MPBottomLineStyle...) {
        for part in parts {
            switch part {
            case .backgroundColor(let color):
                backgroundColor = color
            case .height(let value):
                height = value
            case .hidden(let value):
                hidden = value
            }
        }
    }

}
