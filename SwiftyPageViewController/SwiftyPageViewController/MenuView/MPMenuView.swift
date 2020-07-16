//
//  MPMenuView.swift
//  SwiftyPageViewController
//
//  Created by Qihe_mac on 2020/7/15.
//  Copyright © 2020 QiHe. All rights reserved.
//

import UIKit

public struct MPMenuModel {
    
    var title : String = ""
    var normalIcon: UIImage?
    var selectedIcon: UIImage?
    var normalUrl: String?
    var selectedUrl: String?
}

public enum MPMenuStyle {
    case normalTextFont(UIFont)
    case selectedTextFont(UIFont)
    case normalTextColor(UIColor)
    case selectedTextColor(UIColor)
    case itemSpace(CGFloat)
    case contentInset(UIEdgeInsets)
    case indicatorStyle(MPIndicatorViewStyle)
    case bottomLineStyle(MPBottomLineViewStyle)
    case switchStyle(MPMenuSwitchStyle)
    case layoutStyle(MPMenuLayoutStyle)
}

public enum MPMenuSwitchStyle {
    case line
    case telescopic // 伸缩
}

public enum MPMenuLayoutStyle {
    case flex
    case auto
}


public protocol MPMenuViewDelegate: class {
    func menuView(_ menuView: MPMenuView, didSelectedItemAt index: Int)
}


public class MPMenuView: UIView {
    
    // MARK: - initial methods
    
    public init(parts: [MPMenuStyle]) {
        super.init(frame: .zero)
        for part in parts {
            switch part {
            case .normalTextFont(let font):
                normalTextFont = font
            case .selectedTextFont(let font):
                selectedTextFont = font
            case .itemSpace(let space):
                itemSpace = space
            case .normalTextColor(let color):
                normalTextColor = color
            case .selectedTextColor(let color):
                selectedTextColor = color
            case .contentInset(let inset):
                contentInset = inset
            case .indicatorStyle(let style):
                indicatorViewStyle = style
                indicatorViewStyle.targetView = indicatorView
            case .switchStyle(let style):
                switchStyle = style
            case .bottomLineStyle(let style):
                bottomLineViewStyle = style
                bottomLineViewStyle.targetView = bottomLineView
            case .layoutStyle(let style):
                layoutStyle = style
            }
        }
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - property
    
    private var menuItemViews = [MPMenuItemView]()
    public weak var delegate: MPMenuViewDelegate?
    
    private var normalTextFont = UIFont.systemFont(ofSize: 15)
    private var selectedTextFont = UIFont.systemFont(ofSize: 15)
    
    public var itemSpace:CGFloat = 30.0 {
        didSet {
            stackView.spacing = itemSpace
            layoutIfNeeded()
            layoutSlider()
            scrollView.scrollToSuitablePosition(currentItem, false)
        }
    }
    
    private var normalTextColor = UIColor.darkGray
    private var selectedTextColor = UIColor.red
    public var contentInset = UIEdgeInsets.zero {
        didSet {
            guard let _ = scrollView.superview else {
                return
            }
            
            stackView.snp.updateConstraints { (make) in
                /// 处理1pt的误差
                //make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -1))
                make.leading.equalToSuperview().offset(contentInset.left)
                make.trailing.equalToSuperview().offset(-contentInset.right + 1)
                make.top.equalToSuperview().offset(contentInset.top)
                make.bottom.equalToSuperview().offset(-contentInset.bottom)
                make.height.equalToSuperview()
            }
        }
    }
    public private(set) lazy var indicatorViewStyle = MPIndicatorViewStyle(view: indicatorView)
    public private(set) lazy var bottomLineViewStyle = MPBottomLineViewStyle(view: bottomLineView)
    private var switchStyle = MPMenuSwitchStyle.line
    private var layoutStyle = MPMenuLayoutStyle.flex
    
    private var scrollRate: CGFloat = 0.0 {
            didSet {
                currentItem?.rate = 1.0 - scrollRate
                nextItem?.rate = scrollRate
            }
        }
        
    public var titles = [MPMenuModel]() {
            didSet {
                stackView.arrangedSubviews.forEach({$0.removeFromSuperview()})
                menuItemViews.removeAll()
                guard titles.isEmpty == false else {
                    return
                }
                titles.forEach { (item) in
                    let menuItem = MPMenuItemView(type: .custom)
                    menuItem.config(title: item.title,
                                    normalFont: self.normalTextFont,
                                    selectedFont: self.selectedTextFont,
                                    nomalTextColor: self.normalTextColor,
                                    selectedTextColor: self.selectedTextColor,
                                    normalIcon: item.normalIcon,
                                    selectedIcon: item.selectedIcon,
                                    normalIconUrl: item.normalUrl,
                                    selectedIconUrl: item.selectedUrl)
                    menuItem.addTarget(self, action: #selector(itemClickedAction(button:)), for: .touchUpInside)
                    stackView.addArrangedSubview(menuItem)
                    menuItemViews.append(menuItem)
                }

                currentIndex = 0
                
                stackView.layoutIfNeeded()
                let labelWidth = stackView.arrangedSubviews.first?.bounds.width ?? 0.0
                if self.layoutStyle == .auto {
                    let totalWidth = stackView.arrangedSubviews.map { $0.bounds.width}.reduce(0) { $0 + $1}
                    if totalWidth + CGFloat(self.titles.count - 1) * self.itemSpace <= self.bounds.width - self.contentInset.left - (self.contentInset.right != 0 ? self.contentInset.right : self.contentInset.left) {
                        let diff = self.bounds.width - totalWidth -  self.contentInset.left - (self.contentInset.right != 0 ? self.contentInset.right : self.contentInset.left)
                        self.itemSpace = diff / CGFloat(titles.count - 1)
                        self.scrollView.isScrollEnabled = false
                    }
                    else {
                        self.scrollView.isScrollEnabled = true
                    }
                }
                var progressWidth: CGFloat = 0
                switch switchStyle {
                case .telescopic:
                    progressWidth = indicatorViewStyle.originWidth
                default:
                    switch indicatorViewStyle.shape {
                    case .line:
                        progressWidth = labelWidth + indicatorViewStyle.extraWidth
                    case .round:
                        progressWidth = indicatorViewStyle.height
                    case .triangle:
                        progressWidth = indicatorViewStyle.height + indicatorViewStyle.extraWidth
                    }
                }
                
                let offset = stackView.arrangedSubviews.first?.frame.midX ?? 0.0
                indicatorView.snp.updateConstraints { (make) in
                    switch indicatorViewStyle.shape {
                    case let .line(isAutoWidth, width):
                        if isAutoWidth {
                            make.width.equalTo(progressWidth)
                            make.centerX.equalTo(stackView.snp.leading).offset(offset)
                        }
                        else {
                            make.width.equalTo(width)
                            make.centerX.equalTo(stackView.snp.leading).offset(offset)
                        }
                    default:
                        make.width.equalTo(progressWidth)
                        make.centerX.equalTo(stackView.snp.leading).offset(offset)
                    }

                    let itemHeight = stackView.arrangedSubviews.first?.bounds.height ?? 0.0
                    let diff = (self.bounds.height - itemHeight) * 0.5
                    switch indicatorViewStyle.position {
                    case .contentBottom(let offset):
                        make.bottom.equalToSuperview().offset(-diff + offset)
                    case .contentTop(let offset):
                         make.top.equalToSuperview().offset(diff - offset)
                    default:
                        break
                    }
                }
                checkState(animation: false)
            }
        }
        
        private var itemMidSpace: CGFloat {
            guard let currentLabel = currentItem
                , let nextLabel = nextItem else {
                    return 0.0
            }
            
            let value = nextLabel.frame.minX - currentLabel.frame.midX + nextLabel.bounds.width * 0.5
            return value
        }
        
        private var widthDifference: CGFloat {
            guard let currentLabel = currentItem
                , let nextLabel = nextItem else {
                    return 0.0
            }
            
            let value = nextLabel.bounds.width - currentLabel.bounds.width
            return value
        }
        
        private var centerXDifference: CGFloat {
            guard let currentLabel = currentItem
                , let nextLabel = nextItem else {
                    return 0.0
            }
            let value = nextLabel.frame.midX - currentLabel.frame.midX
            return value
        }
        
        private var nextIndex = 0 {
            didSet {
                guard nextIndex < titles.count
                    , nextIndex >= 0 else {
                    return
                }
                nextItem = menuItemViews[nextIndex]
            }
        }
        
        private var currentIndex = 0 {
            didSet {
                guard currentIndex < titles.count
                    , currentIndex >= 0 else {
                    return
                }
                
                if titles.count == 1 {
                    nextIndex = 0
                }
                else {
                    nextIndex = currentIndex == titles.count - 1 ? currentIndex - 1 : currentIndex + 1
                }
    //            nextIndex = min(currentIndex + 1, titles.count - 1)
                currentItem = menuItemViews[currentIndex]
            }
        }
        private var currentItem: MPMenuItemView?
        private var nextItem: MPMenuItemView?
        

    // MARK: - item click handle
        
    @objc private func itemClickedAction(button: UIButton) {
        guard let index = stackView.arrangedSubviews.firstIndex(of: button) else {
            return
        }
        delegate?.menuView(self, didSelectedItemAt: index)
    }
    
    // MARK: - private methods
    private func initialize() {
        backgroundColor = .white
        clipsToBounds = true
        addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()

        }
        
        
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            /// 处理1pt的误差
            //make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -1))
            make.leading.equalToSuperview().offset(contentInset.left)
            make.trailing.equalToSuperview().offset(-contentInset.right + 1)
            make.top.equalToSuperview().offset(contentInset.top)
            make.bottom.equalToSuperview().offset(-contentInset.bottom)
            make.height.equalToSuperview()
        }
        
        scrollView.addSubview(indicatorView)
        scrollView.sendSubviewToBack(indicatorView)
        indicatorView.snp.makeConstraints { (make) in
            make.centerX.equalTo(stackView.snp.leading).offset(0)
            switch indicatorViewStyle.position {
            case .bottom,.contentBottom:
                make.bottom.equalToSuperview()
            case .center:
                make.centerY.equalToSuperview()
            case .top,.contentTop:
                make.top.equalToSuperview()
            }
        }
        
        addSubview(bottomLineView)
        bottomLineView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
    }
    
    private func clear() {
        stackView.arrangedSubviews.forEach({$0.removeFromSuperview()})
        menuItemViews.removeAll()
    }
    
    public func updateLayout(_ externalScrollView: UIScrollView) {
        guard currentIndex >= 0, currentIndex < titles.count else {
            return
        }
        let scrollViewWidth = externalScrollView.bounds.width
        let offsetX = externalScrollView.contentOffset.x
        let index = Int(offsetX / scrollViewWidth)
        guard index >= 0, index < titles.count else {
            return
        }
        
        currentIndex = index
        let value:CGFloat = offsetX > CGFloat(titles.count - 1) * externalScrollView.bounds.width ? -1 : 1
        scrollRate = value * (offsetX - CGFloat(currentIndex) * scrollViewWidth) / scrollViewWidth
        layoutSlider(scrollRate)
    }
    
    public func checkState(animation: Bool) {
        guard currentIndex >= 0
            , currentIndex < titles.count else {
            return
        }
        menuItemViews.forEach({$0.showNormalStyle()})
        menuItemViews[currentIndex].showSelectedStyle()
        
        currentItem = menuItemViews[currentIndex]
        nextItem = menuItemViews[nextIndex]
        guard let currentLabel = currentItem else {
            return
        }
        scrollView.scrollToSuitablePosition(currentLabel, animation)
    }
    
    func layoutSlider(_ scrollRate: CGFloat = 0.0) {

        let currentWidth = stackView.arrangedSubviews[currentIndex].bounds.width
        let leadingMargin = stackView.arrangedSubviews[currentIndex].frame.midX

        switch switchStyle {
        case .line:
            indicatorView.snp.updateConstraints { (make) in
                switch indicatorViewStyle.shape {
                case let .line(isAutoWidth,width):
                    if isAutoWidth {
                        make.width.equalTo(widthDifference * scrollRate + currentWidth + indicatorViewStyle.extraWidth)
                    }
                    else {
                        make.width.equalTo(width)
                    }
                    
                case .triangle:
                    make.width.equalTo(indicatorViewStyle.height + indicatorViewStyle.extraWidth)
                case .round:
                    make.width.equalTo(indicatorViewStyle.height)
                }
                make.centerX.equalTo(stackView.snp.leading).offset(leadingMargin + itemMidSpace * scrollRate)
            }
        case .telescopic:
            indicatorView.snp.updateConstraints { (make) in
                let rate = (scrollRate <= 0.5 ? scrollRate : (1.0 - scrollRate)) * indicatorViewStyle.elasticValue
                make.width.equalTo(max(centerXDifference * rate + indicatorViewStyle.originWidth, 0))
                make.centerX.equalTo(stackView.snp.leading).offset(leadingMargin + itemMidSpace * scrollRate)
            }
        }
    }
    

    // MARK: - UI
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = self.itemSpace
        return stackView
    }()
    private(set) lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.clipsToBounds = false
        scrollView.delaysContentTouches = true
        return scrollView
    }()
    private lazy var indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = selectedTextColor
        view.snp.makeConstraints({$0.height.equalTo(2.0);$0.width.equalTo(0)})
        return view
    }()
    private let bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.15)
        view.snp.makeConstraints({$0.height.equalTo(0.5)})
        return view
    }()

}
