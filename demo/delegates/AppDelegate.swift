//
//  AppDelegate.swift
//  demo
//
//  Created by Michał Hęćka on 19/04/2022.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    

    var window: UIWindow?
    
    var delegate: SilentPushNotificationService?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        
        delegate = SilentPushNotificationServiceImpl()
        
        guard delegate?.registerPushNotifications(launchOptions: launchOptions) != nil else {
            print("failed to register to push notifications")
            return true
        }
        
        
        return true
    }
    
    


}


