//
//  AppDelegate.swift
//  ForaSoftTestTask
//
//  Created by Михаил Беленко on 09.12.2020.
//  Copyright © 2020 MOB. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)

        let rootViewController = ListAlbumsViewController()
        let navigationController = UINavigationController(rootViewController: rootViewController)

        window!.rootViewController = navigationController
        window!.makeKeyAndVisible()

        return true
    }
}

