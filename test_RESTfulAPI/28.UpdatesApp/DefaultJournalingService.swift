//
//  DefaultJournalingService.swift
//  test_RESTfulAPI
//
//  Created by daher on 2021/6/1.
//

import Foundation

struct DefaultJournalingService {
    
    private let userDefaults: UserDefaults = .standard
    private let notificationsUserDefaultsKey = "com.updates.notifications"
    
    /// Record the fact that we have notified the user.
    func incrementNotificationCount(for version: String) {
        let notificationsUserDefaultsKey = "\(self.notificationsUserDefaultsKey).\(version)"
        let notificationCount = self.notificationCount(for: version) + 1
        userDefaults.setValue(notificationCount, forKey: notificationsUserDefaultsKey)
    }
    
    /// 紀錄不要再提醒我，變負的，例如地10次提醒，使用者點不再提醒我，就變-10
    func dontRemindNotification(for version: String) {
        let notificationsUserDefaultsKey = "\(self.notificationsUserDefaultsKey).\(version)"
        let notificationCount = self.notificationCount(for: version) * -1
        userDefaults.setValue(notificationCount, forKey: notificationsUserDefaultsKey)
    }
    
    /// Returns the number of times we have notified the user about this version.
    func notificationCount(for version: String) -> Int {
        let notificationsUserDefaultsKey = "\(self.notificationsUserDefaultsKey).\(version)"
        return userDefaults.integer(forKey: notificationsUserDefaultsKey)
    }
    
}
