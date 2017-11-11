//
//  UserGroupsTableViewController.swift
//  Homework01
//
//  Created by nnm on 11/2/17.
//  Copyright © 2017 Roman Syrchin. All rights reserved.
//
 

import UIKit
import SwiftyJSON

class UserGroupsTableViewController: UITableViewController {

    var userSession = UserSession.getInstance()
    
    let groups: [String] = [
        "tiny association",
        "afraid historian",
        "known people",
        "actual resolution",
        "decent mood",
        "medical art",
        "old disaster",
        "remarkable friendship"
        ]
    
    func loadData() {
        userSession.vk?.apiGroupsGet(uid: userSession.user.uid) { json in
            self.onGroupsRequestComplete(groups: json)
        }
    }
    
    func onGroupsRequestComplete(groups: JSON) {
        userSession.user.addGroups(json: groups)
        tableView.reloadData()
    }
    
    func updateTitle() {
        navigationItem.title = "\(userSession.user.firstName ?? "someone") groups"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if userSession.user.groups.count == 0 {
            loadData()
        }
        tableView.reloadData()
        updateTitle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userSession.user.groups.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserGroups", for: indexPath) as! UserGroupsTableViewCell

        let group = userSession.user.groups[indexPath.row]

//        cell.imageView?.image = UIImage(named: "gr" + String(indexPath.row+1))
        cell.groupName.text = group.name
        if let ava = group.ava?.image {
            cell.imageView?.image = ava
        } else {
            group.ava?.load {
                ava in
                cell.imageView?.image = ava
                tableView.reloadData()
            }
        }

        // Configure the cell...
//        let groupImage = cell.viewWithTag(1) as! UIImageView
//        groupImage.image = UIImage(named: "images-0")

        return cell
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
