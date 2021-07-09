//
//  UpdatesAppParsing.swift
//  WebViewInterface
//
//  Created by daher on 2021/6/18.
//  Copyright © 2021 com.socialbook. All rights reserved.
//

import Foundation

public class UpdatesAppParsing {
    
    private let api_data: Data
    
    init(api_data: Data) {
        self.api_data = api_data
    }
    
    func merge(defaultInfo: UpdatesApp.UpdatesInfo) -> UpdatesApp.UpdatesInfo {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let updateAppCodable = try? decoder.decode(UpdateAppCodable.self, from: api_data),
              let platform = updateAppCodable.platform,
              let releaseWay = updateAppCodable.releaseWay,
              let notify = updateAppCodable.notify,
              let minRequired = updateAppCodable.minRequired,
              let newVersion = updateAppCodable.newVersion,
              let link = updateAppCodable.link,
              let appID = updateAppCodable.appID,
              let updateMessage = updateAppCodable.updateMessage else {
            return defaultInfo
        }
        
        let updates = UpdatesApp.UpdatesInfo(platform: UpdatesApp.PlatformSource(rawValue: platform)!,
                                             releaseWay: UpdatesApp.ReleaseWaySource(rawValue: releaseWay)!,
                                             notify: UpdatesApp.NotifySource(rawValue: notify)!,
                                             minRequired: minRequired, newVersion: newVersion,
                                             link: link, appID: appID, updateMessage: updateMessage)
        return updates 
    }
    
}
