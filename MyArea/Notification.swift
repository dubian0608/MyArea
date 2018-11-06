//
//  Notification.swift
//  MyArea
//
//  Created by ZhangJi on 11/09/2017.
//  Copyright © 2017 Zhang, Frank. All rights reserved.
//

import UserNotifications

extension AreaTableViewController {
    func addNotification() {
        if areas.count == 0{
            return
        }
        
        let random = Int(arc4random_uniform(UInt32(areas.count)))
        let toadyArea = areas[random]
        
        let content = UNMutableNotificationContent()
        content.title = "推荐区域"
        content.subtitle = "来快活吧"
        content.body = "去\(String(describing: toadyArea.province)) \(String(describing: toadyArea.name))吧"
        content.sound = UNNotificationSound.default()
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(identifier: "Today Area", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            print(error!)
        }
    }
}
