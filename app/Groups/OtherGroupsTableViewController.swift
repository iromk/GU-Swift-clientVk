//
//  OtherGroupsTableViewController.swift
//  clientVk
//
//  Created by Roman Syrchin on 11/2/17.
//  Copyright © 2017 Roman Syrchin. All rights reserved.
//

import UIKit

extension UIImage {
    static func imageWithColor(tintColor: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 80, height: 80)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        tintColor.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

class OtherGroupsTableViewController: UITableViewController {

    let words: [String] = ["mood","instruction","bird","funeral","concept","hall","surgery","difference","advice","reputation","leadership","blood","cheek",
        "painting","revenue","flight","performance","soup","currency","tension","hotel","excitement","manager","confusion","message",
        "warning","location","length","aspect","judgment","penalty","tongue"]
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
         navigationItem.title = "World groups"
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
        return 42
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OtherGroups", for: indexPath) as! OtherGroupsTableViewCell

        // Configure the cell...
        cell.imageView?.image =
                        UIImage.imageWithColor(tintColor:
                            UIColor(red: CGFloat(Double(arc4random_uniform(255))/255.0),
                                    green: CGFloat(Double(arc4random_uniform(255))/255.0),
                                    blue: CGFloat(Double(arc4random_uniform(255))/255.0),
                                    alpha: CGFloat(1))
        )

        var name = ""
        for _ in 0..<3 {
            name += words[Int(arc4random_uniform(UInt32(words.count)))] + " "
        }
        cell.groupName.text = name
        cell.membresCount.text = String(arc4random_uniform(1000))

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
