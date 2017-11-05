//
//  UserStoryTableController.swift
//  Homework01
//
//  Created by nnm on 11/2/17.
//  Copyright © 2017 Roman Syrchin. All rights reserved.
//

import UIKit

class UserStoryTableController: UITableViewController {

    let SegueFriendDetails = "FriendDetails"
    
    let userSession = UserSession.getInstance()
    
    let data: [String] = ["Natalie", "James", "Johny", "Maggie", "Sheldon", "Emma", "Jennifer", "Tony", "Dude", "Albert", "Bober"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = (userSession.user?.name)! + " friends"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueFriendDetails {
            let dst = segue.destination as! FriendViewController
            let selection = sender as! FriendsTableViewCell
            dst.name = selection.friendName?.text
            dst.image = selection.friendPicture?.image
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserFriends", for: indexPath) as! FriendsTableViewCell
        cell.friendName?.text = data[indexPath.row]
        cell.friendPicture?.image = UIImage(imageLiteralResourceName: "images-" + String(indexPath.row))
        return cell
    }

}
