//
//  AppDelegate.swift
//  iOSSensor
//
//  Created by 严铖 on 2020/5/25.
//  Copyright © 2020 kenneth. All rights reserved.
//

import UIKit
import CoreLocation

let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    var locationManager: CLLocationManager!

    func initLocationManager() {
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.allowsBackgroundLocationUpdates = true
        self.locationManager.showsBackgroundLocationIndicator = true
        self.locationManager.requestAlwaysAuthorization()
        
        self.startMySignificantLocationChanges()
        print("hello2")
    }
    
    func startMySignificantLocationChanges() {
        if !CLLocationManager.significantLocationChangeMonitoringAvailable() {
            // The device does not support this service.
            return
        }
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("hello1")
        startTimer()
        startBGTask()

        return
    }
    
    func startTimer() {
        let application = UIApplication.shared
        timer.schedule(deadline: .now(), repeating: .seconds(1), leeway: .milliseconds(10))
        timer.setEventHandler() {
            application.applicationIconBadgeNumber += 1
        }
        
        timer.resume()
        
        sensor.preventStartTwice = false
        sensor.startSensoring()
    }
    
    func startBGTask() {
        let application = UIApplication.shared
        var bg : UIBackgroundTaskIdentifier
        bg = application.beginBackgroundTask(withName: "hello", expirationHandler: nil)
    }
    
    func locationManager(_ manager: CLLocationManager,  didUpdateLocations locations: [CLLocation]) {
        let _ = locations.last!
                   
       // Do something with the location.
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
       if let error = error as? CLError, error.code == .denied {
          // Location updates are not authorized.
          manager.stopMonitoringSignificantLocationChanges()
          return
       }
       // Notify the user of any errors.
    }
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.initLocationManager()
        UNUserNotificationCenter.current().requestAuthorization(options: .badge) { (granted, error) in
            if error != nil {
                // success!
            }
        }
        application.applicationIconBadgeNumber = 1

        return true
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

