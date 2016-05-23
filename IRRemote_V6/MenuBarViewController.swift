//
//  MenuBarViewController.swift
//  IRRemote_V6
//
//  Created by Yuchao Chen on 5/20/16.
//  Copyright © 2016 Yuchao Chen. All rights reserved.
//

import UIKit

protocol unwindItems {
    func whichItem(num: Int)
}

class MenuBarViewController: UIViewController,UINavigationControllerDelegate {
    
    var thisItem: unwindItems!

    @IBOutlet weak var btnLabelAdSettings: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnAdSettingsAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        self.thisItem.whichItem(1)
    }
    
    @IBAction func btnAboutAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        //todo add about logic
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
          
    }


}
