//
//  FriendViewControllerCollectionViewController.swift
//  clientVk
//
//  Created by Roman Syrchin on 11/2/17.
//  Copyright © 2017 Roman Syrchin. All rights reserved.
//

import UIKit

private let reuseIdentifier = "FriendCell"

class FriendViewController: UICollectionViewController {

    let userSession = UserSession.getInstance()
    var friend: Friend?
  
    override func viewDidLoad() {
        super.viewDidLoad()
        print("detailed view didLoad")
        loadData()
//        friend = userSession.user.friends.first { $0.uid == self.uid }

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        
    }
    
    func loadData() {
        if friend!.photos.count > 0 {
            
        } else {
            userSession.vk!.apiPhotosGet(owned: friend!) {
                json in
                //                print("photos of \(self.friend?.uid!) (json)")
                self.friend!.addPhotos(json)
                self.collectionView?.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return friend?.photos.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FriendDetailedCell
    
        // Configure the cell
        if let image = friend?.photos[indexPath.row].image {
            cell.image.image = image
        } else {
            friend?.photos[indexPath.row].load {
                image in
                    cell.image.image = image
//                    collectionView.reloadData()
            }
        }
//        cell.image.image =
//        cell.image.image = UIImage(named: "images-\(arc4random_uniform(10))")
        title = "\(friend?.firstName ?? "friend")'s images"

        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
