//
//  AppDelegate.swift
//  demo
//
//  Created by Michał Hęćka on 19/04/2022.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var notificationHandler = NotificationHandler()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        NotificationHandler.sharedInstance.registerPushNotifications(launchOptions: launchOptions)
        
        return true
    }


}


