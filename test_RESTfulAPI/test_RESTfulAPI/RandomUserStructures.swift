//
//  RandomUserStructures.swift
//  test_RESTfulAPI
//
//  Created by daher on 2021/5/11.
//

import Foundation

struct RandomUser: Codable {
    var results: [RUResult]?
    var info: RUInfo?
}

struct RUResult: Codable{
    var gender: String?
    var name: RUName?
    var location: RULocation?
//    var email: String?
//    var login: RULogin?
//    var dob: RUDob?
//    var registered: RURegistered?
//    var phone: String?
//    var cell: String?
//    var id: RUId?
    var picture: RUPicture?
    var nat: String?
}

struct RUInfo: Codable{
    var seed: String?
    var results: Int?
    var page: Int?
    var version: String?

}

struct RUName: Codable {
    var title: String?
    var first: String?
    var last: String?
}

struct RULocation: Codable {
    var street: RUStreet?
//    var city: String?
//    var state: String?
//    var country: String?
//    var postcode: String?
//    var coordinates: RUCoordinates?
//    var timezone: RUTimezone?
}

struct RUStreet: Codable {
    var number: Int?
    var name: String?
}

struct RUCoordinates: Codable {
    var latitude: Float?
    var longitude: Float?
}

struct RUTimezone: Codable {
    var offset: String?
    var description: String?

}


struct RULogin: Codable {
    var uuid: String?
    var username: String?
    var password: String?
    var salt: String?
    var md5: String?
    var sha1: String?
    var sha256: String?
}

struct RUDob: Codable {
    var date: String?
    var age: String?
}

struct RURegistered: Codable {
    var date: String?
    var age: Int?
    
}

struct RUId: Codable {
    var name: String?
    var value: String?
}

struct RUPicture: Codable {
    var large: String?
    var medium: String?
    var thumbnail: String?
    
}
