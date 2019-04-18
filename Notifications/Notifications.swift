//
//  Notifications.swift
//  Notifications
//
//  Created by Admin on 18/04/2019.
//  Copyright © 2019 Alexey Efimov. All rights reserved.
//

import UIKit
import UserNotifications

class Notifications: NSObject, UNUserNotificationCenterDelegate {

    let notificationCenter = UNUserNotificationCenter.current()

    func requestAutorization() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            print("Permission granted: \(granted)")
            
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        notificationCenter.getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
        }
    }
    
    func scheduleNotification(notificationType: String){
        
        let content = UNMutableNotificationContent()
        let userAction = "User Action"
        
        
        content.title = notificationType
        content.body = "This is example how to create" + notificationType
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.categoryIdentifier = userAction
        
        guard let path = Bundle.main.path(forResource: "favicon", ofType: "png") else {
            return
        }
        let url = URL(fileURLWithPath: path)
        do {
            let attachment = try UNNotificationAttachment(identifier: "favicon", url: url, options: nil)
            content.attachments = [attachment]
        } catch {
            print("the attachment  could not be loaded")
        }

        
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let identifier = "Local Notification"
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error\(error.localizedDescription)")
            }
            let snoozeActoin = UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
            let deleteAction = UNNotificationAction(identifier: "Delete", title: "Delete", options: [.destructive])
            let category = UNNotificationCategory(identifier: userAction, actions: [snoozeActoin, deleteAction], intentIdentifiers: [], options: [])
            
            self.notificationCenter.setNotificationCategories([category])
        }
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.identifier == "Local indification" {
            print("Handling notification with the local Notification Identifier")
        }
        switch  response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            print("Dismiss Action")
        case UNNotificationDefaultActionIdentifier:
            print("Dafaulf")
        case "Snooze" :
            print("Snooze")
            scheduleNotification(notificationType: "Reminder")
        case "Delete":
            print("Delete")
        default:
            print("Unknown action")
        }
        completionHandler()
    }
}

