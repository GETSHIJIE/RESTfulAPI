//
//  UpdatesAppUI.swift
//  test_RESTfulAPI
//
//  Created by daher on 2021/6/1.
//

import Foundation
import StoreKit
import SafariServices

public class UpdatesAppUI: NSObject {

    
    public static func promptToUpdate(_ result: UpdatesApp.Results,
                                      animated: Bool = true,
                                      presentingViewController: UIViewController,
                                      title: String? = nil,
                                      message: String? = nil,
                                      completion: (() -> Void)? = nil) {
        
        let alertTitle: String
        if let title = title {
            alertTitle = title
        } else if let productName = UpdatesApp.productName {
            alertTitle = "\(productName) v\(result.updatesInfo.newVersion) Available"
        } else {
            alertTitle = "Version \(result.updatesInfo.newVersion) Available"
        }
        
        let alertMessage: String? = message ?? result.updatesInfo.updateMessage
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let updateButtonTitle = "現在更新"
        let updateAction = UIAlertAction(title: updateButtonTitle, style: .default) { _ in
            self.openURL(link: result.updatesInfo.link)
            alert.dismiss(animated: animated) {
                if result.updatesInfo.notify == .Mandatory {
                    presentingViewController.present(alert, animated: animated, completion: nil)
                } else {
                    if let completion = completion {
                        completion()
                    }
                }
            }
        }
        let cancelButtonTitle = "之後再說"
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .default) { _ in
            alert.dismiss(animated: animated, completion: completion)
        }
        let deleteButtonTitle = "不要再提醒我"
        let deleteAction = UIAlertAction(title: deleteButtonTitle, style: .destructive) { _ in
            alert.dismiss(animated: animated, completion: completion)
            if let dontRemind = result.journaling.dontRemind {
                dontRemind()
            }
        }
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50));
        loadingIndicator.hidesWhenStopped = true;
        loadingIndicator.style = UIActivityIndicatorView.Style.gray;
        loadingIndicator.startAnimating();
        
        if result.updatesInfo.releaseWay == .Private {
            alert.view.addSubview(loadingIndicator);
        } else {
            alert.addAction(updateAction)
        }
        
        if result.updatesInfo.notify == .Optional {
            alert.addAction(cancelAction)
            alert.addAction(deleteAction)
        }
        
        if result.shouldTask {
            presentingViewController.present(alert, animated: animated, completion: {
                if let increment = result.journaling.increment {
                    increment()
                }
            })
        } else {
            if let completion = completion {
                completion()
            }
        }
    }
    
    private static func openURL(link: String) {
        if let url = URL(string: link){
           if #available(iOS 10.0, *) {
              UIApplication.shared.open(url, options: [:], completionHandler: nil)
           }
           else {
                 if UIApplication.shared.canOpenURL(url as URL) {
                    UIApplication.shared.openURL(url as URL)
                }
           }
        }
    }
}
