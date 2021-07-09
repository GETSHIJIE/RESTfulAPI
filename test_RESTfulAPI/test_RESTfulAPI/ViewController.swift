//
//  ViewController.swift
//  test_RESTfulAPI
//
//  Created by daher on 2021/5/7.
//

import UIKit

class ViewController: UIViewController {

    let rest = RestManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //getUsersList()
        //createUser()
        //getSingleUser()
        //uploadData()

    }
    
    
    @IBAction func openUpdatesAppBtnEvent(_ sender: UIButton) {
        
        UpdatesApp.checkVersionUpdates(urlStr: "https://www.sgw.com.tw/hit-gate/test-Updates-iOS.json") { (result) in
            print(result)
            DispatchQueue.main.async {
                UpdatesAppUI.promptToUpdate(result, presentingViewController: self)
            }
        }
        
    }
    

    func getUsersList() {
        guard let url = URL(string: "https://reqres.in/api/users") else {
            return
        }
        rest.urlQueryParameters.add(value: "2", forkey: "page")
        rest.makeRequest(toURL: url, withHttpMethod: .get) { (results) in
            
            if let response = results.response {
                if response.httpStatusCode != 200 {
                    print("\nRequest failed with HTTP status code", response.httpStatusCode, "\n")
                    return
                }
            }
            
            if let data = results.data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                guard let userData = try? decoder.decode(UserData.self, from: data) else {
                    print("decoder error")
                    return
                }
                print(userData.description)
            }
            
            print("\n\nResponse HTTP Headers:\n")
            if let response = results.response {
                for (key, value) in response.headers.allValues() {
                    print("key=\(key) , value=\(value)")
                }
            }
        }
    }
    
    func createUser() {
        guard let url = URL(string: "https://reqres.in/api/users") else { return }
        rest.requestHttpHeaders.add(value: "application/json", forkey: "Content-Type")
        rest.httpBodyParameters.add(value: "John", forkey: "name")
        rest.httpBodyParameters.add(value: "Developer", forkey: "job")
        rest.makeRequest(toURL: url, withHttpMethod: .post) { (results) in
            guard let response = results.response else { return }
            if response.httpStatusCode == 201 {
                guard let data = results.data else { return }
                let decoder = JSONDecoder()
                guard let jobUser = try? decoder.decode(JobUser.self, from: data) else { return }
                print(jobUser.description)
            }
        }
    }
    
    func getSingleUser() {
        guard let url = URL(string: "https://reqres.in/api/users/1") else {
            return
        }
        
        rest.makeRequest(toURL: url, withHttpMethod: .get) { (results) in
            if let data = results.data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                guard let singleUserData = try? decoder.decode(SingleUserData.self, from: data),
                      let user = singleUserData.data,
                      let avatar = user.avatar,
                      let url = URL(string: avatar) else { return }
                
                self.rest.getData(fromURL: url) { (avatarData) in
                    guard let avatarData = avatarData else { return }
                    let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
                    let saveURL = cachesDirectory.appendingPathComponent("avatar.jpg")
                    try? avatarData.write(to: saveURL)
                    print("\nSaved Avatar URL:\n\(saveURL)\n")
                }
            }
        }
    }
    
    func uploadData() {
        let boundary = "Boundary+\(arc4random())\(arc4random())"
        guard let image = UIImage(named: "test.JPG") else { return }
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }
        guard let url = URL(string: "https://example.com/upload/") else { return }
        
        
        rest.requestHttpHeaders.add(value: "multipart/form-data; boundary=\(boundary)", forkey: "Content-Type")
        rest.httpBodyMultipartParameters.add(value: .init(boundary: boundary,
                                                          key: "image_file", data: data, filename: "test.jpg"))
        rest.makeRequest(toURL: url, withHttpMethod: .post) { (results) in
            if let data = results.data {
                print("data = \(data)")
            }
            
            if let response = results.response {
                print(response.headers)
                print(response.httpStatusCode)
            }
        }
    }
    

}

extension ViewController {
    
}

