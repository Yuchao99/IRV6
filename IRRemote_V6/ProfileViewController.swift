//
//  ProfileViewController.swift
//  IRRemote_V6
//
//  Created by Yuchao Chen on 5/24/16.
//  Copyright © 2016 Yuchao Chen. All rights reserved.
//

import UIKit

protocol unwindProfile {
    func profileSelected(num: Int)
}

class ProfileViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,UINavigationControllerDelegate {

    
    @IBOutlet weak var picker: UIPickerView!
    var thisNum: unwindProfile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        picker.dataSource = self
        
        navigationController?.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "losing him is blue"
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("works")
        dismissViewControllerAnimated(true, completion: nil)
        print(row)
        self.thisNum.profileSelected(row)
    }
}
