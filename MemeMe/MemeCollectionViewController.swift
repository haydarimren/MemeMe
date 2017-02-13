//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by haydar on 12/02/2017.
//  Copyright © 2017 Imren, Haydar. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController: UICollectionViewController {
    // MARK: Properties
    
    // AppDelegate
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // Array of previously shared memes. These will populate the collection view.
    var sharedMemes = (UIApplication.shared.delegate as! AppDelegate).savedMemes
    
    // MARK: Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.sharedMemes = self.appDelegate.savedMemes
        self.collectionView?.reloadData()
    }
    
    // MARK: Collection View Data Source
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sharedMemes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        let meme = self.sharedMemes[(indexPath as NSIndexPath).row]
        
        // Set the image if the cell
        cell.memeImageView?.image = meme.memedImage
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.sharedMemes[(indexPath as NSIndexPath).row]
        detailController.memeIndex = indexPath.row
        self.navigationController!.pushViewController(detailController, animated: true)
    }
}
