//
//  MPIndicator.swift
//  SwiftyPageViewController
//
//  Created by Qihe_mac on 2020/7/14.
//  Copyright © 2020 QiHe. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
public enum MPIndicatorPosition {
    case top
    case center
    case bottom
    case contentBottom(offset: CGFloat)
    case contentTop(offset: CGFloat)
}

public enum MPIndicatorShape {
    /// 是否为自动宽度
    case line(isAutoWidth: Bool,width: CGFloat)
    case triangle
    case round
}

public enum MPIndicatorStyle {
    case backgroundColor(UIColor)
    case originWidth(CGFloat) // only for telescopic switch style
    case elasticValue(CGFloat) // only for telescopic switch style
    case height(CGFloat)
    case extraWidth(CGFloat)
    case cornerRadius(CGFloat)
    case hidden(Bool)
    case position(MPIndicatorPosition)
    case shape(MPIndicatorShape)
}

public class MPIndicatorViewStyle {
    
    public var backgroundColor = UIColor.black {
        didSet {
            targetView?.backgroundColor = backgroundColor
        }
    }
    
    public var height: CGFloat = 2.0 {
        didSet {
            switch shape {
            case .line:
                targetView?.snp.updateConstraints({$0.height.equalTo(height)})
            case .round:
                targetView?.snp.updateConstraints({$0.height.equalTo(height)})
                targetView?.layer.cornerRadius = height * 0.5
            default:
                break
            }
        }
    }
    
    public var hidden = false {
        didSet {
            targetView?.isHidden = hidden
        }
    }
    
    public var cornerRadius: CGFloat = 0.0 {
        didSet {
            switch shape {
            case .line:
                targetView?.layer.cornerRadius = cornerRadius
            default:
                break
            }
        }
    }
    
    var originWidth: CGFloat = 10.0
    var shape = MPIndicatorShape.line(isAutoWidth: true, width: 0)
    var elasticValue: CGFloat = 1.6
    var extraWidth: CGFloat = 0.0
    var position = MPIndicatorPosition.bottom
    
    weak var targetView: UIView? {
        didSet {
            targetView?.backgroundColor = backgroundColor
            targetView?.snp.updateConstraints({$0.height.equalTo(height)})
            targetView?.isHidden = hidden
            switch shape {
            case .line:
                targetView?.layer.cornerRadius = cornerRadius
            case .round:
                targetView?.layer.cornerRadius = height * 0.5
            case .triangle:
                targetView?.layer.cornerRadius = 0
                guard let targetView = targetView else {
                    return
                }
                
                let trianglePath = UIBezierPath()
                switch position {
                case .top:
                    trianglePath.move(to: CGPoint(x: targetView.frame.minX, y: targetView.frame.minY))
                    trianglePath.addLine(to: CGPoint(x: (height + extraWidth), y: targetView.frame.minY))
                    trianglePath.addLine(to: CGPoint(x: (height + extraWidth) * 0.5, y: height))
                case .bottom, .center:
                    trianglePath.move(to: CGPoint(x: targetView.frame.minX, y: height))
                    trianglePath.addLine(to: CGPoint(x: (height + extraWidth), y: height))
                    trianglePath.addLine(to: CGPoint(x: (height + extraWidth) * 0.5, y: targetView.frame.minY))
                case .contentTop:
                    trianglePath.move(to: CGPoint(x: targetView.frame.minX, y: targetView.frame.minY))
                    trianglePath.addLine(to: CGPoint(x: (height + extraWidth), y: targetView.frame.minY))
                    trianglePath.addLine(to: CGPoint(x: (height + extraWidth) * 0.5, y: height))
                case .contentBottom:
                    trianglePath.move(to: CGPoint(x: targetView.frame.minX, y: height))
                    trianglePath.addLine(to: CGPoint(x: (height + extraWidth), y: height))
                    trianglePath.addLine(to: CGPoint(x: (height + extraWidth) * 0.5, y: targetView.frame.minY))
                }
                trianglePath.close()
                trianglePath.lineJoinStyle = .round
                trianglePath.lineCapStyle = .round

                let shapeLayer = CAShapeLayer()
                shapeLayer.path = trianglePath.cgPath
                targetView.layer.mask = shapeLayer
            }
        }
    }
    
    public init(view: UIView) {
        targetView = view
    }
    
    public init(parts: MPIndicatorStyle...) {
        for part in parts {
            switch part {
            case .backgroundColor(let color):
                backgroundColor = color
            case .height(let value):
                height = value
            case .cornerRadius(let value):
                cornerRadius = value
            case .position(let value):
                position = value
            case .extraWidth(let value):
                extraWidth = value
            case .shape(let value):
                shape = value
            case .originWidth(let width):
                originWidth = width
            case .elasticValue(let value):
                elasticValue = value
            case .hidden(let value):
                hidden = value
            }
        }
    }
}
