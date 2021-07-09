//
//  IMImagesDataSource.swift
//  ImagesEditor
//
//  Created by daher on 2021/6/24.
//

import Foundation
import Photos

class IMImagesDataSource {
    public private(set) var imageAssets: [IMImageAsset]
    private var selectedIndexes: [Int]
    
    init(imageAssets: [IMImageAsset]) {
        self.imageAssets = imageAssets
        self.selectedIndexes = []
    }
    
    public func setSelected(at index: Int) {
        if self.selectedIndexes.first(where: { $0 == index }) == nil {
            self.selectedIndexes.append(index)
        }
    }
    
    public func unsetSelected(at index: Int) {
        if let indexInSelectesIndex = self.selectedIndexes.firstIndex(where: { $0 == index }) {
            self.selectedIndexes.remove(at: indexInSelectesIndex)
        }
    }
    
    public func getSelectedIndex(at index: Int) -> Int? {
        return self.selectedIndexes.firstIndex(where: { $0 == index })
    }
    
    public func getSelectedOfCount() -> Int {
        return self.selectedIndexes.count
    }
    
    public func getSelectedOfCount(by mediaType: IMMediaType) -> Int {
        return self.getSelectedOfImageAssets().filter { $0.mediaType == mediaType }.count
    }
    
    public func getSelectedOfImageAssets() -> [IMImageAsset] {
        var result: [IMImageAsset] = []
        self.selectedIndexes.forEach {
            if let image = self.asset(atIndex: $0) {
                result.append(image)
            }
        }
        return result
    }
    
    public func affectedSelectedIndexs(changedIndex: Int) -> [Int] {
        return Array(self.selectedIndexes[changedIndex...])
    }
    
    public func asset(atIndex index: Int) -> IMImageAsset? {
        guard index < self.imageAssets.count, index >= 0 else { return nil }
        return self.imageAssets[index]
    }
    
    public func mediaType(at index: Int) -> IMMediaType? {
        return self.asset(atIndex: index)?.mediaType
    }
    
    public var count: Int {
        return self.imageAssets.count
    }
    
    public func index(asset: IMImageAsset) -> Int? {
        return self.imageAssets.firstIndex(where: { $0 === asset })
    }
    
    public func contains(asset: IMImageAsset) -> Bool {
        return self.index(asset: asset) != nil
    }
    
    public func delete(asset: IMImageAsset) {
        if let index = self.index(asset: asset) {
            self.imageAssets.remove(at: index)
        }
    }
}
