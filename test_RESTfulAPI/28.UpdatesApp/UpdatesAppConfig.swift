//
//  UpdatesAppConfig.swift
//  test_RESTfulAPI
//
//  Created by daher on 2021/6/1.
//

import Foundation

public class UpdatesAppConfig {
    
    private var updatesInfo: UpdatesApp.UpdatesInfo
    
    init(updatesInfo: UpdatesApp.UpdatesInfo) {
        self.updatesInfo = updatesInfo
    }

    func getUpdatesInfo() -> UpdatesApp.UpdatesInfo {
        return self.updatesInfo
    }
    
    public static func Default() -> UpdatesAppConfig {
        let info: UpdatesApp.UpdatesInfo = .init(platform: .iOS,
                                                 releaseWay: .Private,
                                                 notify: .Optional,
                                                 minRequired: UpdatesApp.phoneOSVersion,
                                                 newVersion: UpdatesApp.currentVersion ?? "",
                                                 link: "",
                                                 appID: 0,
                                                 updateMessage: "")
        return UpdatesAppConfig(updatesInfo: info)
    }
}
