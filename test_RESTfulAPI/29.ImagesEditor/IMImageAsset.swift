//
//  IMImageAsset.swift
//  ImagesEditor
//
//  Created by daher on 2021/6/24.
//

import Foundation
import UIKit
import Photos

class IMImageAsset {
    let asset: PHAsset?
    let sourceImage: UIImage?
    let mediaType: IMMediaType
    
    private var fullSizePhotoRequestId: PHImageRequestID?
    
    //var mediaType: IMMediaType
//    var editedThumb: UIImage?
//    var filterdThumb: UIImage?
//    var thumbRequestId: PHImageRequestID?
//    var videoFrames: [CGImage]?
//
//    var thumbChanged: (UIImage) -> Void = { _ in }
//    private var fullSizePhotoRequestId: PHImageRequestID?
    init(asset: PHAsset) {
        self.asset = asset
        self.mediaType = IMMediaType.init(withPHAssetMediaType: asset.mediaType)
        
        self.sourceImage = nil
    }
    
    init(sourceImage: UIImage) {
        self.sourceImage = sourceImage
        self.mediaType = .image
        
        self.asset = nil
    }
    
    func requestImage(in desireSize: CGSize, _ complete: @escaping (UIImage?) -> Void) {
        if let asset = asset {
            _ = IMImageAssetUtil.getPhoto(by: asset, in: desireSize, complete: { (image) in
                guard let image = image else {
                    complete(nil)
                    return
                }
                complete(image)
            })
        }
    }
    
    func requestFullSizePhoto(complete: @escaping (UIImage?) -> Void) {
        if let asset = asset {
            self.fullSizePhotoRequestId = IMImageAssetUtil.getPhoto(by: asset, in: .init(width: 2000, height: 2000)) { (image) in
                
                self.fullSizePhotoRequestId = nil
                complete(image)
            }
        }
    }
}
