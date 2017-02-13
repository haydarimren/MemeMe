//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by haydar on 12/02/2017.
//  Copyright © 2017 Imren, Haydar. All rights reserved.
//

import Foundation
import UIKit

// MARK: - MemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate

class MemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var memeTableView: UITableView!
    
    // MARK: Properties
    
    // App Delegate
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    // Array of previously shared memes. These will populate the collection view.
    var sharedMemes = (UIApplication.shared.delegate as! AppDelegate).savedMemes

    // MARK: Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.sharedMemes = self.appDelegate.savedMemes
        self.memeTableView?.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        memeTableView.delegate = self
        memeTableView.dataSource = self
    }
    
    
    // MARK: Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (UIApplication.shared.delegate as! AppDelegate).savedMemes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell")!
        let meme = (UIApplication.shared.delegate as! AppDelegate).savedMemes[indexPath.row]
        
    
        // Set the name and image
        cell.textLabel?.text = meme.topText[0..<7] + "..." + meme.bottomText[0..<7]
        cell.imageView?.image = meme.memedImage
            
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = (UIApplication.shared.delegate as! AppDelegate).savedMemes[(indexPath as NSIndexPath).row]
        detailController.memeIndex = indexPath.row
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    // Support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {    
            // Delete the current meme (indexPath.row) from the meme collection
            appDelegate.savedMemes.remove(at: indexPath.row)
            
            // Delete the row from the table
            tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
        }
    }

}

// MARK: String Extension for getting substring with a given range

extension String {
    
    var length: Int {
        return self.characters.count
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return self[Range(start ..< end)]
    }
}

