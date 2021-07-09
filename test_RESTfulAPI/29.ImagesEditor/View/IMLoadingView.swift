//
//  IMLoadingView.swift
//  ImagesEditor
//
//  Created by daher on 2021/6/30.
//

import Foundation
import UIKit

class IMLoadingView {
    static let shared = IMLoadingView()
    
    private let transparentView: UIView
    private let indicator: UIActivityIndicatorView
    
    private init() {
        transparentView = UIView()
        transparentView.backgroundColor = UIColor(white: 0, alpha: 0.4)
        transparentView.translatesAutoresizingMaskIntoConstraints = false
        
        indicator = UIActivityIndicatorView()
        indicator.color = .white
        
        transparentView.addSubview(indicator)
        
        indicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indicator.topAnchor.constraint(equalTo: transparentView.topAnchor),
            indicator.leftAnchor.constraint(equalTo: transparentView.leftAnchor),
            indicator.bottomAnchor.constraint(equalTo: transparentView.bottomAnchor),
            indicator.rightAnchor.constraint(equalTo: transparentView.rightAnchor),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show() {
        guard let keyWindow = UIApplication.shared.keyWindow else { return }
        
        keyWindow.addSubview(transparentView)
        
        NSLayoutConstraint.activate([
            transparentView.topAnchor.constraint(equalTo: keyWindow.topAnchor),
            transparentView.leftAnchor.constraint(equalTo: keyWindow.leftAnchor),
            transparentView.bottomAnchor.constraint(equalTo: keyWindow.bottomAnchor),
            transparentView.rightAnchor.constraint(equalTo: keyWindow.rightAnchor),
        ])
        
        transparentView.alpha = 0
        indicator.startAnimating()
        UIView.animate(withDuration: kEnteringAnimationDuration, animations: {
            self.transparentView.alpha = 1
        })
    }
    
    func hide() {
        UIView.animate(
            withDuration: kLeavingAnimationDuration,
            animations: {
                self.transparentView.alpha = 0
        },
            completion: { completed in
                self.transparentView.removeFromSuperview()
                self.indicator.stopAnimating()
        })
    }
    
}
