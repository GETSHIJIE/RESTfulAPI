//
//  UpdatesApp.swift
//  test_RESTfulAPI
//
//  Created by daher on 2021/6/1.
//

import Foundation
import UIKit

public class UpdatesApp {
    
    public static let currentVersion: String? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    public static let productName: String? = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String
    public static let phoneOSVersion:String = UIDevice.current.systemVersion;
    
    private static let defaultJournalingService = DefaultJournalingService()
    private static let defaultConfig = UpdatesAppConfig.Default()
    
    public static func checkVersionUpdates(urlStr: String, completion: @escaping (_ result: Results) -> Void) {
        let rest = RestManager()
        let defaultInfo = defaultConfig.getUpdatesInfo()
        
        guard let url = URL(string: urlStr) else {
            completion(Results(updatesInfo: defaultInfo, shouldTask: false, journaling: .init()))
            return
        }
        
        rest.getData(fromURL: url) { (data) in
            if let data = data {
                let parer = UpdatesAppParsing(api_data: data)
                let updates = parer.merge(defaultInfo: defaultInfo)
                
                let shouldTask =
                    (updates.platform == .iOS) &&
                    (currentVersion != updates.newVersion) &&
                    (defaultJournalingService.notificationCount(for: updates.newVersion) >= 0 ||
                    updates.notify == .Mandatory)

                var journaling = Journaling()
                journaling.increment = {
                    defaultJournalingService.incrementNotificationCount(for: updates.newVersion)
                }
                journaling.dontRemind = {
                    defaultJournalingService.dontRemindNotification(for: updates.newVersion)
                }
                
                completion(Results(updatesInfo: updates, shouldTask: shouldTask, journaling: journaling))
            } else {
                completion(Results(updatesInfo: defaultInfo, shouldTask: false, journaling: .init()))
            }
        }
    }
}


extension UpdatesApp {
    
    enum PlatformSource: String {
        case iOS
        case Android
    }
    
    enum ReleaseWaySource: String {
        case Public
        case Private
    }
    
    enum NotifySource: String {
        case Mandatory
        case Optional
    }
    
    struct UpdatesInfo {
        var platform: PlatformSource
        var releaseWay: ReleaseWaySource
        var notify: NotifySource
        var minRequired: String
        var newVersion: String
        var link: String
        var appID: Int
        var updateMessage: String
        
        init(platform: PlatformSource, releaseWay: ReleaseWaySource, notify: NotifySource,
             minRequired: String, newVersion: String, link: String, appID: Int, updateMessage: String) {
            self.platform = platform
            self.releaseWay = releaseWay
            self.notify = notify
            self.minRequired = minRequired
            self.newVersion = newVersion
            self.link = link
            self.appID = appID
            self.updateMessage = updateMessage
        }
    }
    
    public struct Results {
        var updatesInfo: UpdatesInfo
        var journaling: Journaling
        var shouldTask: Bool
        
        init(updatesInfo: UpdatesInfo, shouldTask: Bool, journaling: Journaling) {
            self.updatesInfo = updatesInfo
            self.shouldTask = shouldTask
            self.journaling = journaling
        }
    }
    
    public struct Journaling {
        var increment: (() -> Void)? = nil
        var dontRemind: (() -> Void)? = nil
    }
    
}
