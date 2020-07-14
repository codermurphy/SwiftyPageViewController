//
//  MPChildViewControllerProtocol.swift
//  SwiftyPageViewController
//
//  Created by Qihe_mac on 2020/7/14.
//  Copyright © 2020 QiHe. All rights reserved.
//

import Foundation
import UIKit

public protocol MPChildViewControllerProtocol where Self: UIViewController {
    func mp_ChildScrollView() -> UIScrollView
}
