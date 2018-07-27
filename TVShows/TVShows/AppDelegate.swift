//
//  AppDelegate.swift
//  TVShows
//
//  Created by Ivan Almer on 05/07/2018.
//  Copyright © 2018 ialmer. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setupAppearance()
        return true
    }

    func setupAppearance() {
        UINavigationBar.appearance().tintColor = UIColor.tvShowsBlack
    }

}

