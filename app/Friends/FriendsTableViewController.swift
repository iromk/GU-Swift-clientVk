//
//  UserStoryTableController.swift
//  clientVk
//
//  Created by Roman Syrchin on 11/2/17.
//  Copyright © 2017 Roman Syrchin. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class FriendsTableViewController: UITableViewController {

    @IBAction func onDemoTap(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        var uids = userSession.testUids
        let sender = self
        uids["> My account <"] = UserDefaults.standard.integer(forKey: "account")
        for (name,uid) in uids.sorted(by: {$0.key < $1.key}) {
            alert.addAction(UIAlertAction(title: name, style: .default) { _ in
                    self.userSession.beginSession(withUid: uid)
                    self.loadData()
                    self.tableView.reloadData()
            })
        }
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive) { _ in
//            self.userSession.state = .closed
            self.userSession.deleteWebViewData {
            self.performSegue(withIdentifier: "Logout", sender: self)}
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in return
        })

        present(alert, animated: true)
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let SegueFriendDetails = "FriendDetails"
    
    let userSession = UserSession.getInstance()
    
    
    override func viewWillAppear(_ animated: Bool) {
//        print("will appear")
    }
    
    func onFriendsRequestComplete(friends: JSON) {
        print("friend request completed")
        userSession.user.addFriends(json: friends)
        activityIndicator.stopAnimating()
        tableView.reloadData()
        updateTitle()
    }
 
    func updateTitle() {
        navigationItem.title = "\(userSession.user.firstName ?? "Jenny") \(userSession.user.lastName ?? "Doe") friends"
    }

    func loadData() {
        if userSession.user.friends.count > 0 {
            updateTitle()
        } else {
            activityIndicator.startAnimating()
            userSession.vk?.apiFriendsGet { json in self.onFriendsRequestComplete(friends: json) }
        }
    }
    
    override func viewDidLoad() {
//        print("did load")
        super.viewDidLoad()
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        print("did appear")
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
        // make avatar in circle
        cell.friendPicture?.layer.cornerRadius = (cell.friendPicture?.frame.size.height)! / 2;
        cell.friendPicture?.layer.masksToBounds = true;
        cell.friendPicture?.layer.borderWidth = 0;

        if let ava = friend.avatar?.image {
//            print("cell \(indexPath.row) \(friend.fullName) \(friend.avatar?.image)")
            cell.friendPicture?.image = ava
        } else {
            cell.friendPicture?.image = nil
//            print("cell calls friend.avatar.load \(friend.avatar?.url)")
            friend.avatar?.load {
                ava in
                    cell.friendPicture?.image = ava
                }
        }
        return cell
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("userSession.user.friends.count \(userSession.user.friends.count)")
        return userSession.user.friends.count
    }
    

}
