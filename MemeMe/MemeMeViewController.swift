//
//  ViewController.swift
//  MemeMe
//
//  Created by Imren, Haydar on 1/22/17.
//  Copyright © 2017 Imren, Haydar. All rights reserved.
//

import UIKit

class MemeMeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // Text Attributes
    let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: Float(-3.0)
        ] as [String: Any]

    
    // Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField! { didSet { topTextField.delegate = self } }
    @IBOutlet weak var bottomTextField: UITextField! { didSet { bottomTextField.delegate = self } }
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    // MARK: Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up initial TextField states
        setTextFieldAttributes(topTextField, "TOP")
        setTextFieldAttributes(bottomTextField, "BOTTOM")
        
        //Set up share and cancel buttons
        shareButton.isEnabled = false
        cancelButton.isEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Camera button should be disabled if not supported.
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        // Subscribe to keyboard notifications
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Unsubscribe from keyboard notifications
        unsubscribeFromKeyboardNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Helper functions
    
    func setTextFieldAttributes(_ textField: UITextField,
                                _ defaultText: String) {
        textField.text = defaultText
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = NSTextAlignment.center
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: NSNotification.Name.UIKeyboardWillHide,
            object: nil
        )
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(
            self,
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: NSNotification.Name.UIKeyboardWillHide,
            object: nil
        )
    }
    
    // Pick an image from either camera or photo library according to the sender button.
    @IBAction func pickImage(_ sender: UIBarButtonItem) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        
        if sender == albumButton {
            pickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        } else if sender == cameraButton {
            pickerController.sourceType = UIImagePickerControllerSourceType.camera
        }
        
        present(pickerController, animated: true, completion: nil)
    }
    
    // MARK: Meme: UI Actions
    
    func generateMemedImage() -> UIImage {
        // Hide toolbars to prevent them appearing on the meme.
        topToolbar.isHidden = true
        bottomToolbar.isHidden = true
        
        // Generate a memed image.
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show toolbars back, after the meme is generated.
        topToolbar.isHidden = false
        bottomToolbar.isHidden = false
        
        return memedImage
    }
    
    
    // MARK: Share: Actions
    
    @IBAction func shareMeme(_ sender: AnyObject) {
        // Generate the Meme
        let memedImage = generateMemedImage()
        
        // Load the Activity view
        let shareController = UIActivityViewController(
            activityItems: [memedImage],
            applicationActivities: nil
        )
        shareController.completionWithItemsHandler = { activity, success, items, error in
            if success {
                self.save(memedImage)
            }
        }
        
        present(shareController, animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        // Set UI elements back to default
        imageView.image = nil
        setTextFieldAttributes(topTextField, "TOP")
        setTextFieldAttributes(bottomTextField, "BOTTOM")
        shareButton.isEnabled = false
        
        // Clear the UI
        dismiss(animated: true, completion: nil)
    }
    
    func save(_ memedImage: UIImage) {
        let meme = Meme(
            topText: topTextField.text!,
            bottomText: bottomTextField.text!,
            originalImage: imageView.image!,
            memedImage: memedImage
        )
        
        // Add it to the memes array on the Application Delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.savedMemes.append(meme)
        
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: Keyboard functions
    
    // If we're editing the bottom label, we want to slide the view out of the way
    // This way, we don't obstruct the field we're editing
    func keyboardWillShow(_ notification: Notification) {
        if bottomTextField.isEditing {
            view.frame.origin.y = -getKeyboardHeight(notification)
            topToolbar.isHidden = true
        }
    }
    
    // Every time the keyboard hides, reset the view position
    func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
        topToolbar.isHidden = false
    }
    
    // Calculates the height of the keyboard for the current device
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as!NSValue
        return keyboardSize.cgRectValue.height
    }
    
    
    // MARK: UITextFieldDelegate functions
    
    // Clear the default texts for textfields when tapped (editing begins).
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == topTextField && textField.text == "TOP")
            || (textField == bottomTextField && textField.text == "BOTTOM") {
            textField.text = ""
        }
    }
    
    // Accept return key from the keyboard.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    // MARK: UIImagePickerControllerDelegate & UINavigationControllerDelegate functions
    
    // Set the image for the imageview and clear the UI state.
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            shareButton.isEnabled = true
            dismiss(animated: true, completion: nil)
        }
    }
}

