//
//  IMImageLibraryConfig.swift
//  ImagesEditor
//
//  Created by daher on 2021/6/24.
//

import Foundation

public class IMImageLibraryConfig {
    public var mediaTypes: [IMMediaType] = [.image]
    public var selectMode: IMSelectMode = .multiple
    public var maxImage: Int = 10
    public var maxVideo: Int = 10
}
