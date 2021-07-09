//
//  UpdatesAppStructer.swift
//  test_RESTfulAPI
//
//  Created by daher on 2021/6/1.
//

import Foundation

struct UpdateAppCodable: Codable, CustomStringConvertible {
    var platform: String?
    var releaseWay: String?
    var notify: String?
    var minRequired: String?
    var newVersion: String?
    var link: String?
    var appID: Int?
    var updateMessage: String?

    var description: String {
        return """
        ------------
        ------------
        """
    }
}

