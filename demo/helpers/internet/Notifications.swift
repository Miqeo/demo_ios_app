//
//  Notifications.swift
//  demo
//
//  Created by Michał Hęćka on 02/06/2022.
//

import UIKit
import UserNotifications

class NotificationHandler : NSObject, UNUserNotificationCenterDelegate {
    
    
    static let sharedInstance = NotificationHandler()
    
    override init(){
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    func registerPushNotifications(launchOptions : [UIApplication.LaunchOptionsKey: Any]?) {//register for remote notifications when authorised
        
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
    
//    func pushAnyViewController<T : UIViewController>(viewController : T, storyboardName : String) {
//        guard let nextViewController = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: String(describing: T.self)) as? T else {return}
//        viewController.navigationController?.pushViewController(nextViewController, animated: true)
//    }
    
    func goToSaidViewController(aps : [String : AnyObject]) -> UIBackgroundFetchResult{//rudimentary opening new instances of view controllers or sending data for notification observers
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        
        let nav = UIApplication.shared.keyWindow?.rootViewController as! UINavigationController
        
        var viewController = UIViewController()
        
        guard let name: String = aps["VC"] as? String else { return .noData }
        
        switch name {
        case "c0":
            NotificationCenter.default.post(Notification(
                name:Notification.Name(rawValue: "ReceivePosition"),
                object: IndexPath(row: aps["row"] as! Int, section: aps["sec"] as! Int)
            ))
            return .newData
        case "c1":
            viewController = storyboard.instantiateViewController(withIdentifier: "web_image") as! WebImageViewController
            (viewController as! WebImageViewController).imageUrl = URL(string: aps["link_url"] as! String)
            break
        case "c2":
            viewController = storyboard.instantiateViewController(withIdentifier: "demo")
            break
        default:
            print("Nothing")
            return .noData
        }
        
        nav.pushViewController(viewController, animated: true)

        
        return .newData
    }
    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//    }
    
    //used for normal push notifications (while app is inactive or in background)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("opened from notification notification center")
        guard let aps = response.notification.request.content.userInfo["aps"] as? [String : AnyObject] else {
            completionHandler()
            return
        }

        print(aps)

        if aps["content-available"] as? Int == 1 {

            NotificationCenter.default.post(name: Notification.Name("ReceiveData"), object: nil)
            completionHandler()
            return
        }

        _ = goToSaidViewController(aps: aps)
        completionHandler()

    }
    
}




extension AppDelegate{
    
    //used in ios12 onwards for silent push notifications
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("opened from notification remote")
        
        guard let aps = userInfo["aps"] as? [String : AnyObject] else {
            completionHandler(.failed)
            return
        }

        print(aps)

        if aps["content-available"] as? Int == 1 {//sending data to notification observer
            NotificationCenter.default.post(Notification(
                name:Notification.Name(rawValue: "ReceiveData"),
                object: nil
            ))
            completionHandler(.newData)
            return
        }

        if (application.applicationState == .active) {
            completionHandler(.noData)
            return
        }

        completionHandler(NotificationHandler.sharedInstance.goToSaidViewController(aps: aps))
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {//to debug, getting device token
        let tokenParts = deviceToken.map{data in String(format: "%02.2hhx", data)}
        let token = tokenParts.joined()

        print("token granted \(token)")

    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
}
