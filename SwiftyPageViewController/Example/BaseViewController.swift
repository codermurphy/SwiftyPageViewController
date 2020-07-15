//
//  BaseViewController.swift
//  SwiftyPageViewController
//
//  Created by Qihe_mac on 2020/7/15.
//  Copyright © 2020 QiHe. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    deinit {
        debugPrint(Self.self)
    }

}
