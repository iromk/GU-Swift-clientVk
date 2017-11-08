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
//        print("will appear")
        activityIndicator.startAnimating()
        userSession.vk?.apiFriendsGet { json in self.onFriendsRequestComplete(friends: json) }
    }
    
    func onFriendsRequestComplete(friends: JSON) {
        print("friend request complete")
        userSession.addFriends(json: friends)
        activityIndicator.stopAnimating()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        print("appeared")
//        print("table view friends count:\(userSession.user.friends.count)")
        if userSession.user.friends.count == 0 {
            navigationItem.title = "still loading friends"
        } else {
            navigationItem.title = "\(userSession.user.firstName ?? "Jenny") \(userSession.user.lastName ?? "Doe") friends"
        }
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueFriendDetails {
            let dst = segue.destination as! FriendViewController // контроллер коллекции
            let selection = sender as! FriendsTableViewCell // ячейка куда тапнули
            dst.name = selection.friendName?.text
            dst.image = selection.friendPicture?.image
//            dst.uid = selection.uid // и в контроллере коллекции соответсвенно некая принимающая ячейка
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserFriends", for: indexPath) as! FriendsTableViewCell
//        cell.uid = userSession.user.friends[indexPath.row].uid // в класс ячейки дбавить поле uid
        cell.friendName?.text = userSession.user.friends[indexPath.row].fullName
        //        cell.friendName?.text = data[indexPath.row]
        //        cell.friendPicture?.image = UIImage(imageLiteralResourceName: "images-" + String(indexPath.row))
        return cell
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return data.count
        print("table view friends count:\n\(userSession.user.friends.count)")
        return userSession.user.friends.count
    }
    

}
