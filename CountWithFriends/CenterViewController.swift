//
//  CenterViewController.swift
//  CountWithFriends
//
//  Created by joy on 6/29/16.
//  Copyright © 2016 Andrew Bihl. All rights reserved.
//

import UIKit

protocol CenterViewControllerDelegate {
     func toggleRightPanel()
//     func collapseSidePanels()
}

class CenterViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let cellID = "cellID"
    
    var delegate: CenterViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.registerClass(CategoryCell.self, forCellWithReuseIdentifier: cellID)
        
        collectionView?.backgroundColor = UIColor.yellowColor()

    }


    @IBAction func onProfilePressed(sender: AnyObject) {
        
        delegate?.toggleRightPanel()
    }
    

    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath) as! CategoryCell
    
        return cell
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 2
    
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        

        return CGSizeMake(view.frame.width - 40, 50)
    }
    
    
    
}





