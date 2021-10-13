//
//  AppDelegate.swift
//  Test
//
//  Created by Ксения Чепурных on 31.05.2021.
//

import UIKit
import UserNotifications
import BackgroundTasks

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let notificationCentr = UNUserNotificationCenter.current()
    
    var record: Record = Record()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        requestAuthorization()
        
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "k.chepurnykh.fetchRecord", using: nil) { (task) in
            self.handleAppRefreshTask(task: task as! BGAppRefreshTask)
            print("task registered")
        }
        
        return true
    }
    
    func handleAppRefreshTask(task: BGAppRefreshTask) {
        print("task handler")
        
//        let date: String = {
//            let date = Date()
//            return Date().fogmatedDate(date: date)
//        }()
        
//        Parser.shared.fetchRecord(date: date) { record in
//            self.record = record
//            
//            if self.record.value > Value.savedValue {
//                self.scheduleNotification(notificationType: "Уведомление")
//            }
//            
//            task.setTaskCompleted(success: true)
//        }
        
        scheduleBackgroundFetch()
        
    }
    
    func scheduleBackgroundFetch() {
        let fetchTask = BGAppRefreshTaskRequest(identifier: "k.chepurnykh.fetchRecord")
        fetchTask.earliestBeginDate = Date(timeIntervalSinceNow: 60)
        do {
            try BGTaskScheduler.shared.submit(fetchTask)
            print("task scheduled")
        } catch {
            print("Unable to schedule task: \(error.localizedDescription)")
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func requestAuthorization() {
        notificationCentr.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            
        }
    }
    
    func scheduleNotification(notificationType: String) {
        let content = UNMutableNotificationContent()
        
        content.title = notificationType
        content.body = "Курс доллара повысился!"
        content.sound = UNNotificationSound.default
        content.badge = 1
        
        let id = "Local Notification"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        notificationCentr.add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}

