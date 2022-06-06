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
        
        notificationHandler.registerPushNotifications(launchOptions: launchOptions)
//        NotificationHandler.sharedInstance.registerPushNotifications(launchOptions: launchOptions)
        
//        let notificationOption = launchOptions?[.remoteNotification]
//
//        if let notification = notificationOption as? [String : AnyObject], let aps = notification["aps"] as? [String : AnyObject] {
//
//            print("launched from notification")
//
//            print(aps)
////            (window?.rootViewController as? PhotoTableViewController)?.tableView.selectRow(at: IndexPath(row: 20, section: 5), animated: true, scrollPosition: .middle)
//        }
        
        return true
    }


}


