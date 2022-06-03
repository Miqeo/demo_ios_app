//
//  AppDelegate.swift
//  demo
//
//  Created by Michał Hęćka on 19/04/2022.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    
    var notificationHandler = NotificationHandler()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        notificationHandler.registerPushNotifications()
        
        let notificationOption = launchOptions?[.remoteNotification]
        
        if let notification = notificationOption as? [String : AnyObject], let aps = notification["aps"] as? [String : AnyObject] {
            
            print("launched from notification")
            
            print(aps)
//            (window?.rootViewController as? PhotoTableViewController)?.tableView.selectRow(at: IndexPath(row: 20, section: 5), animated: true, scrollPosition: .middle)
        }
        
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        
//
        
        guard let aps = userInfo["aps"] as? [String : AnyObject] else {
            completionHandler(.failed)
            return
        }
        
        if aps["content-available"] as? Int == 1 {
            NotificationCenter.default.post(name: Notification.Name("ReceiveData"), object: nil)
//            NotificationCenter.default.post(name: Notification.Name("ReceivePosition"), object: IndexPath(row: aps["row"] as! Int, section: aps["sec"] as! Int))
            completionHandler(.newData)
            return
        }
        
        if (application.applicationState == .background || application.applicationState == .active) {
            completionHandler(.noData)
            return
        }
            
        
        print("opened again from notification")
        
        print(aps)
//        let rootViewController = self.window!.rootViewController as! UINavigationController
//        if let photo = rootViewController.presentedViewController as? PhotoTableViewController {
//
//            photo.tableView.scrollToRow(at: IndexPath(row: 6, section: 2), at: .middle, animated: true)
//        }
        
        
        
        
        guard let name: String = aps["VC"] as? String else { completionHandler(.noData); return }
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let nav = self.window!.rootViewController as! UINavigationController
        
        var viewController = UIViewController()
        
        switch name {
        case "c0":
            NotificationCenter.default.post(name: Notification.Name("ReceivePosition"), object: IndexPath(row: aps["row"] as! Int, section: aps["sec"] as! Int))
            completionHandler(.newData)
            return
        case "c1":
            viewController = storyboard.instantiateViewController(withIdentifier: "web_image") as! WebImageViewController
            (viewController as! WebImageViewController).imageUrl = URL(string: aps["link_url"] as! String)
            break
        case "c2":
            viewController = storyboard.instantiateViewController(withIdentifier: "demo")
            break
        default:
            print("Nothing")
            return
        }
        
        nav.pushViewController(viewController, animated: true)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map{data in String(format: "%02.2hhx", data)}
        let token = tokenParts.joined()
        
        print("token granted \(token)")
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    


}

