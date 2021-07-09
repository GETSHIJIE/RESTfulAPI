//
//  PhotoLibraryViewController.swift
//  test_RESTfulAPI
//
//  Created by daher on 2021/7/8.
//

import UIKit

class PhotoLibraryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var photos: [UIImage] = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    @IBAction func openBtnEvent(_ sender: UIBarButtonItem) {
        let controller = IMImageLibraryViewController.init(config: .init())
        controller.delegate = self
        present(controller, animated: true, completion: nil)
    }
}

extension PhotoLibraryViewController: UITableViewDelegate {
    
}

extension PhotoLibraryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PhotoLibraryTableViewCell
        cell.myImageView.image = photos[indexPath.row]
        return cell
    }
}

extension PhotoLibraryViewController: IMImageLibraryViewControllerDelegate {
    func imImageLibraryViewController(_ controller: IMImageLibraryViewController, didFinishPickingPhotoWith photos: [UIImage]) {
        controller.dismiss(animated: true) {
            self.photos = photos.map{ $0 }
            self.tableView.reloadData()
        }
    }
    
    func imImageLibraryViewControllerCancel(_ controller: IMImageLibraryViewController) {
        
    }
}
