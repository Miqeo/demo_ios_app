//
//  SilentNotificationsModel.swift
//  demo
//
//  Created by Michał Hęćka on 07/06/2022.
//

import UIKit
import UserNotifications

import FirebaseCore
import FirebaseMessaging

protocol SilentPushNotificationService {
    func registerPushNotifications(launchOptions : [UIApplication.LaunchOptionsKey: Any]?)
    func didReceiveRemoteNotification(application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) -> UIBackgroundFetchResult
}

extension Dictionary where Key == AnyHashable{//to dict of known key type
    func toDictionaryJson() -> [String : AnyObject]? {
         return self as? [String : AnyObject]
    }
}

class SilentPushNotificationServiceImpl: NSObject, SilentPushNotificationService, MessagingDelegate {
    
    let gcmMessageIDKey = "gcm.message_id"
    
    override init(){
        super.init()

        Messaging.messaging().delegate = self
    }
    
    func registerPushNotifications(launchOptions : [UIApplication.LaunchOptionsKey: Any]?) {//register for remote notifications when authorised
        
        Messaging.messaging().subscribe(toTopic: "nothx") { error in
          print("Subscribed to nothx topic")
        }
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { [weak self] granted, _ in
            print("notification permission : \(granted)")
            guard granted else { return }
            self?.getNotificationSettings()
        }
    }
    
    private func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("notifications settings : \(settings)")
            
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func didReceiveRemoteNotification(application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) -> UIBackgroundFetchResult {
        guard let aps = userInfo.toDictionaryJson()?["aps"] else {
            print("failed parsing json")
            return .failed
        }

        print(aps)

        if aps["content-available"] as? Int == 1 {//sending data to notification observer
            NotificationCenter.default.post(Notification(
                name:Notification.Name(rawValue: "ReceiveData"),
                object: nil
            ))
            return .newData
        }
        return .noData
        
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase token: \(String(describing: fcmToken))")
        
        Messaging.messaging().token { token, error in
          if let error = error {
            print("Error fetching FCM token: \(error)")
          } else if let token = token {
            print("FCM  token: \(token)")
          }
        }

    }
}

extension AppDelegate{
    
    
    //used for silent push notifications
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("opened from notification remote")
        
        completionHandler(delegate?.didReceiveRemoteNotification(application: application,
                                                                didReceiveRemoteNotification: userInfo
                                                                ) ?? .failed)
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {//to debug, getting device token
        let tokenParts = deviceToken.map{data in String(format: "%02.2hhx", data)}
        let token = tokenParts.joined()
        
        Messaging.messaging().apnsToken = deviceToken;


        print("token granted \(token)")

    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
}
