//
//  CategoryCell.swift
//  CountWithFriends
//
//  Created by joy on 7/3/16.
//  Copyright © 2016 Andrew Bihl. All rights reserved.
//

import UIKit


class CategoryCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private let cellID = "appCellID"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let appsCollectionView: UICollectionView =  {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Horizontal
       
        let collectionView = UICollectionView(frame: .zero , collectionViewLayout: layout)
        
//        let collectionView = UICollectionView(frame: CGRectMake(0, 75, self.view.frame.width, self.view.frame.height-75), collectionViewLayout: layout)
        
        collectionView.backgroundColor = UIColor.blueColor()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
    
        
        return collectionView
    }()
    

 
    
    
    
    func setupViews() {
        backgroundColor = UIColor.greenColor()
        addSubview(appsCollectionView)
        
        appsCollectionView.dataSource = self
        appsCollectionView.delegate = self
        
        appsCollectionView.registerClass(AppCell.self, forCellWithReuseIdentifier:cellID)
        
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-8-[v0]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": appsCollectionView]))
        
        
          addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": appsCollectionView]))
        
        
        
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

        return CGSizeMake(50, frame.height)
    }
    
    
}



class AppCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
    backgroundColor = UIColor.purpleColor()
    
    }
    
    
}

