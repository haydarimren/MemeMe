//
//  FontPickerViewController.swift
//  MemeMe
//
//  Created by Imren, Haydar on 1/23/17.
//  Copyright © 2017 Imren, Haydar. All rights reserved.
//

import UIKit

class FontPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
  
    // App Delegate
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    // Outlets
    @IBOutlet weak var pickerView: UIPickerView!
    
    // The model for the font picker
    var pickerData: [String] = [String]()
    
    
    // MARK: Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make background transparent/blurred
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        
        // Connect data:
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        // Input data into the Array:
        var index: Int = 0
        var counter: Int = 0
        for familyName in UIFont.familyNames as [String] {
            for fontName in UIFont.fontNames(forFamilyName: familyName) as [String] {
                if fontName == appDelegate.fontName {
                    index = counter
                }
                pickerData.append(fontName)
                counter = counter + 1
            }
        }
        
        // Select default value for pickerView
        pickerView.selectRow(index, inComponent: 0, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: UIPickerViewDelegate & UIPickerViewDataSource functions.
    
    // Returns the number of components for PickerView.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Returns the number of rows the component has in the PickerView
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    
    // MARK: UI Actions
    
    // Sets the fontName in App Delegate and sends a notification to parent view controller
    @IBAction func setFont(_ sender: Any) {
        // Get the current selected value from the picker and set it as the fontName.
        appDelegate.fontName = self.pickerView(pickerView, titleForRow: pickerView.selectedRow(inComponent: 0), forComponent: 0)!
        
        // Send a notification to parent view.
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fontChangeNotification"), object: nil)
        
        // Return back to parent view
        self.view.removeFromSuperview()
    }
}
