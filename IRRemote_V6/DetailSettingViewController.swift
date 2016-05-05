//
//  DetailSettingViewController.swift
//  IRRemote_V6
//
//  Created by Yuchao Chen on 5/5/16.
//  Copyright © 2016 Yuchao Chen. All rights reserved.
//

import UIKit

class DetailSettingViewController: UIViewController {

    //declare all the UI components
    @IBOutlet weak var labelMainTitle: UILabel!
    @IBOutlet weak var labelSubtitle: UILabel!
    @IBOutlet weak var sliderMain: UISlider!
    @IBOutlet weak var btnLabelValue: UIButton!
    @IBOutlet weak var labelUnitMark: UILabel!
    @IBOutlet weak var btnLabelSend: UIButton!
    
    var settings = Configuration()
    var type =   Configuration.settingTypes()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sliderMainAction(sender: AnyObject) {
    }
    @IBAction func btnValue(sender: AnyObject) {
    }
    @IBAction func btnSend(sender: AnyObject) {
    }
    


}
