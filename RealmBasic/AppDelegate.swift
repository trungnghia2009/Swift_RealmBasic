//
//  AppDelegate.swift
//  RealmBasic
//
//  Created by trungnghia on 16/09/2022.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        configureRealm()
        return true
    }
    
    func configureRealm() {
        let config = Realm.Configuration(

           schemaVersion: 2,  //Increment this each time your schema changes
            migrationBlock: { migration, oldSchemaVersion in

              if (oldSchemaVersion < 1) {
                    //If you need to transfer any data
                   //(in your case you don't right now) you will transfer here

              }
           })
        
        Realm.Configuration.defaultConfiguration = config
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
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        EventBusApplicationBecomeActive.updateActiveState(state: true)
    }


}

