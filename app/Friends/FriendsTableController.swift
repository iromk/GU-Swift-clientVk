//
//  UserStoryTableController.swift
//  Homework01
//
//  Created by nnm on 11/2/17.
//  Copyright © 2017 Roman Syrchin. All rights reserved.
//

import UIKit

class FriendsTableController: UITableViewController {

    let SegueFriendDetails = "FriendDetails"
    
    let userSession = UserSession.getInstance()
    
    let data: [String] = ["Natalie", "James", "Johny", "Maggie", "Sheldon", "Emma", "Jennifer", "Tony", "Dude", "Albert"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = (userSession.user?.name)! + "'s story"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueFriendDetails {
            let dst = segue.destination as! FriendViewController
            let selection = sender as! UITableViewCell
            dst.name = selection.textLabel?.text
            dst.image = selection.imageView?.image
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        cell.imageView?.image = UIImage(imageLiteralResourceName: "images-" + String(indexPath.row))
        return cell
    }

}
