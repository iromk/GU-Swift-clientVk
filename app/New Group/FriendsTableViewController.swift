//
//  UserStoryTableController.swift
//  Homework01
//
//  Created by nnm on 11/2/17.
//  Copyright © 2017 Roman Syrchin. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class FriendsTableViewController: UITableViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let SegueFriendDetails = "FriendDetails"
    
    let userSession = UserSession.getInstance()
    
    // offline test data
//    let data: [String] = ["Natalie", "James", "Johny", "Maggie", "Sheldon", "Emma", "Jennifer", "Tony", "Dude", "Albert", "Bober"]

    
    override func viewWillAppear(_ animated: Bool) {
        print("will appear")
    }
    
    func onFriendsRequestComplete(friends: JSON) {
        print("friend request complete")
        userSession.user.addFriends(json: friends)
        activityIndicator.stopAnimating()
        tableView.reloadData()
        updateTitle()
    }
 
    func updateTitle() {
        navigationItem.title = "\(userSession.user.firstName ?? "Jenny") \(userSession.user.lastName ?? "Doe") friends"
    }

    override func viewDidLoad() {
        print("did load")
        super.viewDidLoad()
        activityIndicator.startAnimating()
        userSession.vk?.apiFriendsGet { json in self.onFriendsRequestComplete(friends: json) }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("did appear")
        updateTitle()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueFriendDetails {
            let dst = segue.destination as! FriendViewController
            let selection = sender as! FriendsTableViewCell
            dst.friend = selection.friend
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserFriends", for: indexPath) as! FriendsTableViewCell
        let friend = userSession.user.friends[indexPath.row]
        cell.friend = friend
        cell.friendName?.text = friend.fullName

        cell.friendPicture?.layer.cornerRadius = (cell.friendPicture?.frame.size.height)! / 2;
        cell.friendPicture?.layer.masksToBounds = true;
        cell.friendPicture?.layer.borderWidth = 0;

        if let ava = friend.avatar?.image {
            cell.friendPicture?.image = ava
        } else {
            friend.avatar?.load {
                ava in
                    cell.friendPicture?.image = ava
                    tableView.reloadData()
                }
        }
        //        cell.friendPicture?.image = UIImage(imageLiteralResourceName: "images-" + String(indexPath.row))
        return cell
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userSession.user.friends.count
    }
    

}
