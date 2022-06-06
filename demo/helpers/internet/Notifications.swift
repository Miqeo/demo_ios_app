//
//  Notifications.swift
//  demo
//
//  Created by Michał Hęćka on 02/06/2022.
//

import Foundation
import UserNotifications
import UIKit

class NotificationHandler {
    
    
    static let sharedInstance = NotificationHandler()
    
    
    func registerPushNotifications(launchOptions : [UIApplication.LaunchOptionsKey: Any]?) {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { [weak self] granted, _ in
            print("notification permission : \(granted)")
            guard granted else { return }
            self?.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("notifications settings : \(settings)")
            
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func pushAnyViewController<T : UIViewController>(viewController : T, storyboardName : String) {
        guard let nextViewController = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: String(describing: T.self)) as? T else {return}
        viewController.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    func goToSaidViewController(aps : [String : AnyObject], completionHandler : @escaping  (UIBackgroundFetchResult) -> ()){
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let nav = UIApplication.shared.keyWindow?.rootViewController as! UINavigationController//self.window!.rootViewController as! UINavigationController
        
        var viewController = UIViewController()
        
        guard let name: String = aps["VC"] as? String else { completionHandler(.noData); return }

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
    
}

extension AppDelegate : UNUserNotificationCenterDelegate{
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("opened from notification 1")
        guard let aps = userInfo["aps"] as? [String : AnyObject] else {
            print("no aps")
            completionHandler(.failed)
            return
        }

        if aps["content-available"] as? Int == 1 {
            NotificationCenter.default.post(name: Notification.Name("ReceiveData"), object: nil)
            completionHandler(.newData)
            return
        }

        if (application.applicationState == .background || application.applicationState == .active) {
            completionHandler(.noData)
            return
        }

        print("opened from notification 2")

        
        NotificationHandler().goToSaidViewController(aps: aps) { fetchResult in
            completionHandler(fetchResult)
        }
        
        completionHandler(.newData)
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
