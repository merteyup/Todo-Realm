//
//  AppDelegate.swift
//  Destini
//
//  Created by Philipp Muellauer on 01/09/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        // Realm file location.
        // print(Realm.Configuration.defaultConfiguration.fileURL)
        #warning("1. step")
        do {
            // Init realm and keep this for be able to see possible errors.
            // It's not in use so keep it as a _
            _ = try Realm()
        } catch {
            print("Error initializing new realm : \(error)")
        }
        
        return true
    }

    
}



