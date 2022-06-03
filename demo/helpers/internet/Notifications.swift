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
    
    
    
    func registerPushNotifications() {
        
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
}
