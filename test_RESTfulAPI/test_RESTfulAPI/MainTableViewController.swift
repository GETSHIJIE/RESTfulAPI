//
//  MainTableViewController.swift
//  test_RESTfulAPI
//
//  Created by daher on 2021/5/11.
//

import UIKit

class MainTableViewController: UITableViewController {

    let restManager = RestManager()
    var randomUsers = RandomUserEntity()
    var favorites = RandomUserEntity()
    var page = PageEntity()
    
    var currentScrollCellIndex: Int = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        refresh(loadType: .all);
    }
    
    

    
    private func refresh(loadType: LoadType) {
        
        let _page   = page.getPage()
        let _count  = page.getCount()
        
        guard let url = URL(string: "https://randomuser.me/api/?page=\(_page)&results=\(_count)&seed=abc") else {
            return
        }
        
        restManager.makeRequest(toURL: url, withHttpMethod: .get) { [self] (results) in
            if let data = results.data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                guard let user = try? decoder.decode(RandomUser.self, from: data) else {
                    print("decoder error")
                    return
                }
                
                randomUsers.add(randomUser: user)
                
                switch loadType {
                case .all:
                    DispatchQueue.main.async {
                        tableView.reloadData()
                    }
                    break
                case .insert:
                    print("currentScrollCellIndex \(currentScrollCellIndex)")
                    print("randomUsers.getTotalUser() \(randomUsers.getTotalUser())")
                    

                    
                    DispatchQueue.main.async {
                        tableView.beginUpdates()
                        for i in currentScrollCellIndex+1..<randomUsers.getTotalUser() {
                            if (i/page.getCount() + 1) > page.getPage() {
                                page.insertPage()
                            }
                            tableView.insertRows(at: [IndexPath(row: i, section: 0)], with: .automatic)
                        }
                        tableView.endUpdates()
                    }
                    
                    break
                }
                
                
            }
        }
        
    }
    
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return randomUsers.getTotalUser()
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MainTableViewCell
        
        let sec = indexPath.row / page.getCount()
        let tag = indexPath.row % page.getCount()

        print("index = \(indexPath.row)  page = \(sec)", "tag = \(tag)")
        
        let randomUser = randomUsers.userResult(section: sec, row: tag)
        
        
        let largePicName = randomUser.picture?.large ?? ""
        cell.largeImageView.load(urlString: largePicName)
        
        let firstName = randomUser.name?.first ?? ""
        let lastName = randomUser.name?.last ?? ""
        cell.userName.text = "(\(indexPath.row))" + firstName + ", " + lastName
        
        let streetNumber = randomUser.location?.street?.number ?? 0
        cell.userStreetNumber.text = String(streetNumber)
        let streetName = randomUser.location?.street?.name ?? ""
        cell.userStreetName.text = streetName
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("!willDisplay \(indexPath.row)")
        print(randomUsers.getTotalUser() - 1)
        print(currentScrollCellIndex)
        
        if ((indexPath.row == randomUsers.getTotalUser() - 1) && (indexPath.row != currentScrollCellIndex)) {
            print("refresh")
            currentScrollCellIndex = indexPath.row;
            refresh(loadType: .insert)
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension MainTableViewController {
    enum LoadType {
        case all
        case insert
    }
    
    
    struct RandomUserEntity {
        private var randomUsers: [RandomUser] = []
        private var totalUser: Int = 0
        
        mutating func add(randomUser: RandomUser) {
            randomUsers.append(randomUser)
            totalUser = totalUser + (randomUser.results?.count ?? 0)
        }
        
        func userResult(section: Int, row: Int) -> RUResult {
            allUserResults(section: section)[row]
        }
        func allUserResults(section: Int) -> [RUResult] {
            return randomUsers[section].results ?? []
        }
        func getUserResultCount(section: Int) -> Int {
            return (randomUsers.count > 0) ? randomUsers[section].results?.count ?? 0 : 0
        }
        func getTotalUser() -> Int {
            return totalUser
        }
        
        func totalSection() -> Int {
            return randomUsers.count
        }
    }
    
    struct PageEntity {
        private var page: Int = 1
        private let count: Int = 10
        
        mutating func insertPage() {
            page = page + 1
        }
        
        func getPage() -> Int {
            return page
        }
        
        func getCount() -> Int {
            return count
        }
    }
}
