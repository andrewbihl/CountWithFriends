////
////  TheirTurnCollectionView.swift
////  CountWithFriends
////
////  Created by joy on 7/12/16.
////  Copyright © 2016 Andrew Bihl. All rights reserved.
////
//
//import UIKit
//
//private let reuseIdentifier = "Cell"
//
//class TheirTurnCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource{
//    
//    
//    //    var matches = Array<(matchID: String, opponentDisplayName: String)>()
//    
//    func viewDidLoad() {
//        
//        self.backgroundColor = UIColor.darkSpringGreen(0.75)
//
//
//        
//        // Uncomment the following line to preserve selection between presentations
//        // self.clearsSelectionOnViewWillAppear = false
//        
//
//    }
//    
//    // MARK: UICollectionViewDataSource
//    
//    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
//    
//    
//    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of items
//        
//        return 10
//    }
//    
//    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
//        
//        cell.backgroundColor = UIColor.darkSpringGreen(0.7)
//        
//        // Configure the cell
//        return cell
//}
//
//}