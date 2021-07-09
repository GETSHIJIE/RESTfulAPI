//
//  IMImageLibraryCollectionViewCell.swift
//  ImagesEditor
//
//  Created by daher on 2021/6/24.
//

import Foundation
import UIKit

class IMImageLibraryCollectionViewCell: UICollectionViewCell {
    static let reuseId = String(describing: IMImageLibraryCollectionViewCell.self)

    weak var imImageView: IMImageView!
    weak var selectButton: UIButton!
    weak var selectIndex: UILabel!
    weak var videoInfoView: UIView!
    weak var videoLengthLabel: UILabel!
    
    private weak var imImageAsset: IMImageAsset?
    private var selectMode: IMSelectMode!
    private weak var imageAsset: IMImageAsset?
    
    public var onTapSelect = {}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func loadView(imageAsset: IMImageAsset, selectMode: IMSelectMode, selectedIndex: Int?) {
        self.selectMode = selectMode
        self.imageAsset = imageAsset
        
        if selectMode == .single {
            
        }
        
        imageAsset.requestImage(in: .init(width: 300, height: 300)) { (image) in
            if let image = image {
                self.imImageView.image = image
            }
        }
        
        if imageAsset.mediaType == .video {
            self.videoInfoView.isHidden = false
        }
        
        self.performSelectionAnimation(selectedIndex: selectedIndex)
    }
    
    @IBAction func onTapSelects(_ sender: Any) {
        self.onTapSelect()
    }
    
    func performSelectionAnimation(selectedIndex: Int?) {
        if let selectedIndex = selectedIndex {
            switch selectMode {
            case .multiple:
                selectIndex.isHidden = false
                selectIndex.text = "\(selectedIndex + 1)"
                selectButton.setImage(UIImage.init(named: "check_on"), for: .normal)
                break
            case .single:
                selectIndex.isHidden = true
                selectButton.setImage(UIImage.init(named: "single_check_on"), for: .normal)
                break
            default:
                break
            }
        } else {
            self.selectIndex.isHidden = true
            selectButton.setImage(UIImage.init(named: "check_off"), for: .normal)
        }
    }
}

extension IMImageLibraryCollectionViewCell {
    private func setupView() {
        contentView.clipsToBounds = true
        
        
        //*** image view ***
        let imImageView = IMImageView()
        self.imImageView = imImageView
        imImageView.contentMode = .scaleAspectFill
        contentView.addSubview(imImageView)
        imImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor)
        ])
        
        //*** video info view ***
        let videoInfoView = UIView()
        self.videoInfoView = videoInfoView
        videoInfoView.isHidden = true
        contentView.addSubview(videoInfoView)
        videoInfoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            videoInfoView.heightAnchor.constraint(equalToConstant: 24),
            videoInfoView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            videoInfoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            videoInfoView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
        ])
        
        //*** video icon ***
        let videoIcon = UIImageView()
        videoIcon.contentMode = .scaleAspectFill
        videoInfoView.addSubview(videoIcon)
        videoIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            videoIcon.heightAnchor.constraint(equalToConstant: 8),
            videoIcon.widthAnchor.constraint(equalToConstant: 17),
            videoIcon.leftAnchor.constraint(equalTo: videoInfoView.leftAnchor, constant: 8),
            videoIcon.centerYAnchor.constraint(equalTo: videoInfoView.centerYAnchor)
        ])
        
        //*** video length ***
        let videoLengthLabel = UILabel()
        self.videoLengthLabel = videoLengthLabel
        videoLengthLabel.font = .systemFont(ofSize: 12, weight: .medium)
        videoLengthLabel.textColor = .white
        videoInfoView.addSubview(videoLengthLabel)
        videoLengthLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            videoLengthLabel.rightAnchor.constraint(equalTo: videoInfoView.rightAnchor, constant: -8),
            videoLengthLabel.centerYAnchor.constraint(equalTo: videoInfoView.centerYAnchor)
        ])
        
        //*** select button ***
        let selectButton = UIButton()
        self.selectButton = selectButton
        selectButton.addTarget(self, action: #selector(onTapSelects(_:)), for: .touchUpInside)
        contentView.addSubview(selectButton)
        selectButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            selectButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            selectButton.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            selectButton.heightAnchor.constraint(equalToConstant: 40),
            selectButton.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        //*** select index ***
        let selectedIndex = UILabel()
        self.selectIndex = selectedIndex
        selectedIndex.font = .systemFont(ofSize: 15)
        selectedIndex.textColor = .white
        contentView.addSubview(selectedIndex)
        selectedIndex.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            selectedIndex.centerXAnchor.constraint(equalTo: selectButton.centerXAnchor),
            selectedIndex.centerYAnchor.constraint(equalTo: selectButton.centerYAnchor),
        ])
        
    }
}
