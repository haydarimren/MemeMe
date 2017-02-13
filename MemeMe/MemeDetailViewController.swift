//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by haydar on 12/02/2017.
//  Copyright © 2017 Imren, Haydar. All rights reserved.
//

import UIKit

// MARK: - MemeDetailViewController: UIViewController

class MemeDetailViewController: UIViewController {
    
    // MARK: Properties
    
    var meme: Meme!
    var memeIndex: Int!
    
    // MARK: Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.imageView!.image = meme.memedImage
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    // MARK : Button Actions
    
    @IBAction func editMeme(_ sender: UIBarButtonItem) {
        let editorContoller = self.storyboard!.instantiateViewController(withIdentifier: "MemeMeViewController") as! MemeMeViewController
        editorContoller.editableMeme = meme!
        editorContoller.editableMemeIndex = memeIndex!
        self.navigationController!.pushViewController(editorContoller, animated: true)
    }
}
