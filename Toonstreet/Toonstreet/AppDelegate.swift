//
//  AppDelegate.swift
//  Toonstreet
//
//  Created by Kavin Soni on 18/11/21.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
        IQKeyboardManager.shared.toolbarPreviousNextAllowedClasses = [UIScrollView.self, UIView.self]//To Solve Scrolling issue
        
        
    
//        if TSUser.shared.isLogin == true{
//            navigateToTabViewController()
//        }else{
//
//        }
        return true
    }

    func navigateToTabViewController(){
     
        
        let destinationTab:TSTabBarControllerViewController = UIStoryboard(storyboard: .Main).instantiateViewController()
//        self.storyboard?.instantiateViewController(withIdentifier: "TSTabBarControllerViewController") as? TSTabBarControllerViewController
        self.window?.rootViewController = destinationTab
        self.window?.makeKeyAndVisible()
    }
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

