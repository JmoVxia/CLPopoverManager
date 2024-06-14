//
//  AppDelegate.swift
//  Demo
//
//  Created by Chen JmoVxia on 2022/11/7.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = CLPopupController()
        window?.makeKeyAndVisible()
        return true
    }
}
