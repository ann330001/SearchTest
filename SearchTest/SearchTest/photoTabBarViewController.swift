//
//  photoTabBarViewController.swift
//  SearchTest
//
//  Created by Chen Zhi-Han on 2020/7/23.
//  Copyright © 2020 Chen Zhi-Han. All rights reserved.
//

import UIKit

class photoTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "搜尋結果 " + APIManager.instance.searchText
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print(item.title)
        if item.title == "Featured" {
            self.title = "搜尋結果 " + APIManager.instance.searchText
        } else {
            self.title = "我的最愛"
        }
    }
}

