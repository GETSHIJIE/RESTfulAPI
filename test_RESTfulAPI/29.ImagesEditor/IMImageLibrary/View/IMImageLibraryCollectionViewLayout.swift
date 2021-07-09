//
//  IMImageLibraryCollectionViewLayout.swift
//  ImagesEditor
//
//  Created by daher on 2021/6/24.
//

import Foundation
import UIKit

class IMImageLibraryCollectionViewLayout: UICollectionViewFlowLayout {
    
    let numberOfColumns: CGFloat = 3
    let padding: CGFloat = 1
    
    override init() {
        super.init()
        self.minimumInteritemSpacing = self.padding
        self.minimumLineSpacing = self.padding
        
        let itemSizeW = (UIScreen.main.bounds.size.width - ((self.numberOfColumns - 1) * self.padding)) / numberOfColumns
        self.itemSize = CGSize(width: itemSizeW, height: itemSizeW)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
