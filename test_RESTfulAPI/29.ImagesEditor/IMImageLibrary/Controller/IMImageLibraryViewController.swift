//
//  IMImageLibraryViewController.swift
//  ImagesEditor
//
//  Created by daher on 2021/6/24.
//

import UIKit

protocol IMImageLibraryViewControllerDelegate: class {
    func imImageLibraryViewController(_ controller: IMImageLibraryViewController, didFinishPickingPhotoWith photos: [UIImage])
    func imImageLibraryViewControllerCancel(_ controller: IMImageLibraryViewController)
}

class IMImageLibraryViewController: UIViewController {
    
    public var delegate: IMImageLibraryViewControllerDelegate?

    // MARK: - Outlet
    private weak var imageCollectionView: UICollectionView!
    private weak var doneButton: UIButton!
    private weak var cancelButton: UIButton!
    private weak var titleLabel: UILabel!
    
    private var config: IMImageLibraryConfig
    
    private var dataSource: IMImagesDataSource! {
        didSet {
            
        }
    }
    
    // MARK: - Init
    public init(config: IMImageLibraryConfig) {
        self.config = config
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        initializeViews()
        setupView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.dataSource == nil {
            self.requestAndFetchAssets()
        }
    }
    
    @objc private func btnDoneEvent(_ sender: Any) {
        processDetermination()
    }
    
    @objc private func btnCancelEvent(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.imImageLibraryViewControllerCancel(self)
        }
    }
    
    private func setupView() {
   
        self.doneButton.setTitle("完成", for: .normal)
        self.cancelButton.setTitle("取消", for: .normal)
        self.titleLabel.text = "我的相簿"
        
        self.imageCollectionView.register(IMImageLibraryCollectionViewCell.self,
                                          forCellWithReuseIdentifier: IMImageLibraryCollectionViewCell.reuseId)
        self.imageCollectionView.dataSource = self
        self.imageCollectionView.delegate = self
    }
    
    
    private func requestAndFetchAssets() {
        IMImageAssetUtil.requestAuthorizationForPhotoAccess {
            self.fetchAssets()
        } rejected: {
            print("reject")
        }
    }
    
    private func fetchAssets() {
        let assets = IMImageAssetUtil.getAssets(allow: config.mediaTypes)
        let imImageAsset = assets.map { IMImageAsset(asset: $0) }
        self.dataSource = IMImagesDataSource.init(imageAssets: imImageAsset)
        
        if self.dataSource.count > 0 {
            self.imageCollectionView.reloadData()
            self.imageCollectionView.selectItem(at: IndexPath(row: self.dataSource.count-1, section: 0),
                                                animated: false,
                                                scrollPosition: .bottom)
        }
        
    }
    
    private func processDetermination() {
        IMLoadingView.shared.show()
        var dict = [Int: UIImage]()
        DispatchQueue.global(qos: .userInitiated).async {
            let multiTask = DispatchGroup()
            for (index, element) in self.dataSource.getSelectedOfImageAssets().enumerated() {
                multiTask.enter()
                element.requestFullSizePhoto { (image) in
                    guard let image = image else { return }
                    dict[index] = image
                    print(index)
                    multiTask.leave()
                }
            }
            multiTask.wait()
            
            let result = dict.sorted(by: { $0.key < $1.key }).map { $0.value }
            DispatchQueue.main.async {
                self.delegate?.imImageLibraryViewController(self, didFinishPickingPhotoWith: result)
                IMLoadingView.shared.hide()
            }
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - UICollectionViewDataSource
extension IMImageLibraryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let total = self.dataSource?.count {
            return total
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: IMImageLibraryCollectionViewCell.reuseId, for: indexPath)
                as? IMImageLibraryCollectionViewCell,
              let asset = dataSource.asset(atIndex: indexPath.item) else {
            return UICollectionViewCell()
        }
        
        cell.loadView(imageAsset: asset, selectMode: config.selectMode,
                      selectedIndex: dataSource.getSelectedIndex(at: indexPath.item))
        
        cell.onTapSelect = { [unowned self, unowned cell] in
            if let selectIndex = dataSource.getSelectedIndex(at: indexPath.item) {
                dataSource.unsetSelected(at: indexPath.item)
                cell.performSelectionAnimation(selectedIndex: nil)
                self.reloadAffectedCellByChangingSelection(changedIndex: selectIndex)
            } else {
                tryToAddPhotoToSelectedList(at: indexPath.item)
            }
        }
        
        
        return cell
    }
    
    public func reloadAffectedCellByChangingSelection(changedIndex: Int) {
        let affectedList = dataSource.affectedSelectedIndexs(changedIndex: changedIndex)
        let indexPaths = affectedList.map { return IndexPath(row: $0, section: 0) }
        imageCollectionView.reloadItems(at: indexPaths)
    }
    
    public func tryToAddPhotoToSelectedList(at index: Int) {
        
        if config.selectMode == .multiple {
            guard let fmMediaType = dataSource.mediaType(at: index) else { return }
            var canAdd: Bool = true
            
            switch fmMediaType {
            case .image:
                if dataSource.getSelectedOfCount(by: .image) >= config.maxImage {
                    canAdd = false
                }
                break
            case .video:
                if dataSource.getSelectedOfCount(by: .video) >= config.maxVideo {
                    canAdd = false
                }
                break
            case .unsupported:
                canAdd = false
                break
            
            }
            
            if canAdd {
                dataSource.setSelected(at: index)
                imageCollectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
            }
            
        } else {
            var indexPaths: [IndexPath] = []
            dataSource.getSelectedOfImageAssets().forEach { (asset) in
                guard let index = dataSource.index(asset: asset) else { return }
                indexPaths.append(IndexPath.init(row: index, section: 0))
                dataSource.unsetSelected(at: index)
            }
            
            dataSource.setSelected(at: index)
            indexPaths.append(IndexPath.init(row: index, section: 0))
            imageCollectionView.reloadItems(at: indexPaths)
            
        }
    }
}


// MARK: - UICollectionViewDelegate
extension IMImageLibraryViewController: UICollectionViewDelegate {
    
}



private extension IMImageLibraryViewController {
    func initializeViews() {
        
        //*** header view ***
        let headerView = UIView()
        headerView.backgroundColor = .white
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            headerView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])

        
        //*** menu container ***
        let menuContainer = UIView()
        menuContainer.backgroundColor = .white
        menuContainer.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(menuContainer)
        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                menuContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                menuContainer.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 20)
            ])
        }
        NSLayoutConstraint.activate([
            menuContainer.leftAnchor.constraint(equalTo: headerView.leftAnchor),
            menuContainer.rightAnchor.constraint(equalTo: headerView.rightAnchor),
            menuContainer.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            menuContainer.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        //*** cancel button ***
        let cancelButton = UIButton(type: .system)
        self.cancelButton = cancelButton
        cancelButton.setTitleColor(kMainColor, for: .normal)
        cancelButton.addTarget(self, action: #selector(btnCancelEvent(_:)), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        menuContainer.addSubview(cancelButton)
        NSLayoutConstraint.activate([
            cancelButton.leftAnchor.constraint(equalTo: menuContainer.leftAnchor, constant: 16),
            cancelButton.centerYAnchor.constraint(equalTo: menuContainer.centerYAnchor),
        ])
        
        //*** done button ***
        let doneButton = UIButton(type: .system)
        self.doneButton = doneButton
        doneButton.setTitleColor(kMainColor, for: .normal)
        doneButton.addTarget(self, action: #selector(btnDoneEvent(_:)), for: .touchUpInside)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        menuContainer.addSubview(doneButton)
        NSLayoutConstraint.activate([
            doneButton.rightAnchor.constraint(equalTo: menuContainer.rightAnchor, constant: -16),
            doneButton.centerYAnchor.constraint(equalTo: menuContainer.centerYAnchor),
            doneButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 40),
        ])
        
        //*** title label ***
        let titleLabel = UILabel()
        self.titleLabel = titleLabel
        titleLabel.textColor = kBlackColor
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        menuContainer.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: menuContainer.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: menuContainer.centerYAnchor),
        ])
        
        
        //*** collection ***
        let imageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: IMImageLibraryCollectionViewLayout())
        self.imageCollectionView = imageCollectionView
        imageCollectionView.backgroundColor = .clear
        imageCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageCollectionView)
        NSLayoutConstraint.activate([
            imageCollectionView.topAnchor.constraint(equalTo: menuContainer.bottomAnchor),
            imageCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            imageCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
        ])
    }
}
