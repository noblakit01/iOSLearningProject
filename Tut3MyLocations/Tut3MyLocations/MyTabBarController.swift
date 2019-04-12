//
//  MyTabBarController.swift
//  Tut3MyLocations
//
//  Created by luan on 6/30/16.
//  Copyright © 2016 luantran. All rights reserved.
//

import UIKit

class MyTabBarController: UITabBarController {
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func childViewControllerForStatusBarStyle() -> UIViewController? {
        return nil
    }
}
