//
//  DetailSettingViewController.swift
//  IRRemote_V6
//
//  Created by Yuchao Chen on 5/5/16.
//  Copyright © 2016 Yuchao Chen. All rights reserved.
//

import UIKit
import AVFoundation

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
    var operation: Model!
    var engine: AVAudioEngine!
    var node: Protocal!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingSetting()
        
        operation = Model()
        node = Protocal()
        engine = AVAudioEngine()
        
        node.frequency = 125
        
        let format = AVAudioFormat(standardFormatWithSampleRate: node.sampleRate, channels: 1)
        
        
        engine.attachNode(node)
        let mixer = engine.mainMixerNode
        engine.connect(node, to: mixer, format: format)
        do {
            try engine.start()
        } catch let error as NSError {
            print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadingSetting(){
        switch type {
        case .rampUP:
            labelMainTitle.text = "Ramp Up Setting"
            labelSubtitle.text = "Select Ramp Up Value"
            btnLabelValue.setTitle(String(settings.ruValue), forState: .Normal)
            labelUnitMark.text = "Seconds"
        case .delayToOff:
            labelMainTitle.text = "Delay To Off Setting"
            labelSubtitle.text = "Select Delay To Off Value"
            btnLabelValue.setTitle(String(settings.delM), forState: .Normal)
            
        case .rampDown:
            labelMainTitle.text = "Ramp Down Setting"
            labelSubtitle.text = "Select Ramp Down Value"
            btnLabelValue.setTitle(String(settings.rdValue), forState: .Normal)
            labelUnitMark.text = "Seconds"
        default:
            labelMainTitle.text = "Setting"
            labelSubtitle.text = "Select Value"
            btnLabelValue.setTitle("0", forState: .Normal)
            labelUnitMark.text = "NULL"
        }
    }
    
    @IBAction func sliderMainAction(sender: AnyObject) {
    }
    @IBAction func btnValue(sender: AnyObject) {
    }
    @IBAction func btnSend(sender: AnyObject) {
        
        
        
    }
    


}
