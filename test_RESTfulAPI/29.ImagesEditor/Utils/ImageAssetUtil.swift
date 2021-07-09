//
//  ImageAssetUtil.swift
//  ImagesEditor
//
//  Created by daher on 2021/6/24.
//

import Foundation
import Photos
import UIKit

public class IMImageAssetUtil {

    static func getPhoto(by photoAsset: PHAsset, in desireSize: CGSize, complete: @escaping (UIImage?) -> Void) -> PHImageRequestID {
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .fast
        options.isSynchronous = false
        options.isNetworkAccessAllowed = true
        
        let manager = PHImageManager.default()
        let newSize = CGSize(width: desireSize.width, height: desireSize.height)
        
        let phID = manager.requestImage(for: photoAsset, targetSize: newSize, contentMode: .aspectFit, options: options) { (image, _) in
            complete(image)
        }
        return phID
    }
    
    static func getAssets(allow mediaTypes: [IMMediaType]) -> [PHAsset] {
        let fetchOptions = PHFetchOptions()
        fetchOptions.includeAssetSourceTypes = [.typeUserLibrary, .typeCloudShared, .typeiTunesSynced]
        fetchOptions.predicate = NSPredicate(format: "mediaType IN %@", mediaTypes.map({$0.value()}))
        
        let fetchResult = PHAsset.fetchAssets(with: fetchOptions)
        guard fetchResult.count > 0 else {
            return []
        }
        
        var photoAssets = [PHAsset]()
        fetchResult.enumerateObjects { (asset, index, _) in
            photoAssets.append(asset)
        }
        return photoAssets
    }
    
    static func requestAuthorizationForPhotoAccess(authorized: @escaping () -> Void, rejected: @escaping () -> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                if status == .authorized {
                    authorized()
                } else {
                    rejected()
                }
            }
        }
    }
    
    static func canAccessPhotoLib() -> Bool {
        return PHPhotoLibrary.authorizationStatus() == .authorized
    }
}
