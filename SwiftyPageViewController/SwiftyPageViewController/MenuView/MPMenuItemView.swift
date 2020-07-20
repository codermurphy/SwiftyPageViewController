//
//  MPMenuItemView.swift
//  SwiftyPageViewController
//
//  Created by Qihe_mac on 2020/7/15.
//  Copyright © 2020 QiHe. All rights reserved.
//

import UIKit

extension UIFont {
    var weightValue: Float {
        guard let value = traits[.weight] as? NSNumber else {
            return 0
        }
        return value.floatValue
    }
    
    private var traits: [UIFontDescriptor.TraitKey: Any] {
        return fontDescriptor.object(forKey: .traits) as? [UIFontDescriptor.TraitKey: Any] ?? [:]
    }
}


extension UIColor {
    
    var rgb: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var fRed: CGFloat = 0
        var fGreen: CGFloat = 0
        var fBlue: CGFloat = 0
        var fAlpha: CGFloat = 0
        if getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            return (red: fRed, green: fGreen, blue: fBlue, alpha: fAlpha)
        } else {
            return (red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        }
    }
}

public enum MPMenuItemTextAndImageType {
    case `default`
    case right
}

public extension MPMenuItemView {
    
    func mp_centerTextAndImage(type: MPMenuItemTextAndImageType,spacing: CGFloat) {
        switch type {
        case .default:
            let insetAmount = spacing / 2
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
            contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
        case .right:
            guard
                let imageSize = imageView?.image?.size,
                let text = titleLabel?.text,
                let font = titleLabel?.font
                else { return }
            let titleSize = text.size(withAttributes: [.font: font])
            let insetAmount = spacing / 2
            titleEdgeInsets = UIEdgeInsets(top: 0, left: -(imageSize.width + insetAmount), bottom: 0, right: insetAmount + imageSize.width)
            imageEdgeInsets = UIEdgeInsets(top: 0, left: titleSize.width + insetAmount, bottom: 0, right: -(titleSize.width + insetAmount))
            contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
            
        }
    }
}


open class MPMenuItemView: UIButton {
    
    
    
    // MARK: - property
    private var title: String = ""
    private var normalFont: UIFont = .systemFont(ofSize: 12)
    private var selectedFont: UIFont = .systemFont(ofSize: 12)
    private var nomalTextColors = UIColor.white.rgb
    private var selectedTextColors = UIColor.red.rgb
    
    internal var rate: CGFloat = 0.0 {
        didSet {
            guard rate > 0.0, rate < 1.0 else {
                return
            }
            //configAttributedText(rate)
        }
    }
    

    // MARK: - config
    
    open func config(title: String,
         normalFont: UIFont,
         selectedFont: UIFont,
         nomalTextColor: UIColor,
         selectedTextColor: UIColor,
         normalIcon: UIImage?,
         selectedIcon: UIImage?,
         normalIconUrl: String?,
         selectedIconUrl: String?,
         TextAndImageType: MPMenuItemTextAndImageType = .default,
         textAndImageSpacing: CGFloat = 5 ) {
        
        self.title = title
        self.normalFont = normalFont
        self.selectedFont = selectedFont
        
        self.nomalTextColors = nomalTextColor.rgb
        self.selectedTextColors = selectedTextColor.rgb
        
        let normalAttrString = NSAttributedString(string: title, attributes: [NSAttributedString.Key.font : normalFont,NSAttributedString.Key.foregroundColor : nomalTextColor])
        let selectedAttString = NSAttributedString(string: title, attributes: [NSAttributedString.Key.font : selectedFont,NSAttributedString.Key.foregroundColor : selectedTextColor])
        
        self.setAttributedTitle(normalAttrString, for: .normal)
        self.setAttributedTitle(selectedAttString, for: .selected)
        
        self.setImage(normalIcon, for: .normal)
        self.setImage(selectedIcon, for: .selected)

        if normalIcon != nil  || selectedIcon != nil || normalIconUrl != nil || selectedIconUrl != nil {
            self.mp_centerTextAndImage(type: TextAndImageType, spacing: textAndImageSpacing)
        }
        
    }
    
    public func showNormalStyle() {
        //self.isSelected = false
        self.configAttributedText(0)
    }
    
    public func showSelectedStyle() {
        //self.isSelected = true
        self.configAttributedText(1)
    }
    
    private func configAttributedText(_ rate: CGFloat) {
        if rate == 0 {
            
            self.isSelected = false
        }
        else if rate == 1 {
            self.isSelected = true
        }
        else{
            let r = nomalTextColors.red + (selectedTextColors.red - nomalTextColors.red) * rate
            let g = nomalTextColors.green + (selectedTextColors.green - nomalTextColors.green) * rate
            let b = nomalTextColors.blue + (selectedTextColors.blue - nomalTextColors.blue) * rate
            let a = nomalTextColors.alpha + (selectedTextColors.alpha - nomalTextColors.alpha) * rate
                 
            let strokeWidth = floor(CGFloat(selectedFont.weightValue - normalFont.weightValue) * 8.0) * rate
            let fontSize = self.normalFont.pointSize + (selectedFont.pointSize - normalFont.pointSize) * rate
            let font = self.normalFont.withSize(fontSize)

            let color =  UIColor(red: r, green: g, blue: b, alpha: a)
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: font,
                    .foregroundColor: color,
                    .strokeWidth: -abs(strokeWidth),
                    .strokeColor: color
                ]

            let attrsText = NSAttributedString(string: self.title, attributes: attributes)
            self.setAttributedTitle(attrsText, for: .normal)
        }

    }


}
