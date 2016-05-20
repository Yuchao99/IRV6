//
//  ViewController.swift
//  IRRemote_V6
//
//  Created by Yuchao Chen on 4/29/16.
//  Copyright © 2016 Yuchao Chen. All rights reserved.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController, unwindValue {
    
    //init all the business parameters
    var operations = Model()
    var settings = Configuration()
    var engine: AVAudioEngine!
    var node: Protocal!
    

    //declare all the UI components
    @IBOutlet weak var labelRampUp: UILabel!
    @IBOutlet weak var labelDelayToOff: UILabel!
    @IBOutlet weak var labelRampDown: UILabel!
    @IBOutlet weak var labelMaxDimming: UILabel!
    @IBOutlet weak var labelMinDimming: UILabel!
    @IBOutlet weak var labelSensitivity: UILabel!
    @IBOutlet weak var ALS: UILabel!
    @IBOutlet weak var labelTestmode: UILabel!
    
    
    @IBOutlet weak var btnLabelRampUp: UIButton!
    @IBOutlet weak var btnLabelDelayToOff: UIButton!
    @IBOutlet weak var btnLabelRampDown: UIButton!
    @IBOutlet weak var btnLabelMaxDimming: UIButton!
    @IBOutlet weak var btnLabelMinDimming: UIButton!
    @IBOutlet weak var btnLabelSensitivity: UIButton!
    @IBOutlet weak var btnLabelALS: UIButton!
    @IBOutlet weak var btnLabelTestmode: UIButton!
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSetting(settings)

        //start your engine
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
    
    func loadSetting(config: Configuration){
        //two parts, first time open app, load default setting; loading from loal files
        //now just use default setting
        btnLabelRampUp.setTitle(String(config.ruValue)+" Secs", forState: .Normal)
        btnLabelRampDown.setTitle(String(config.rdValue)+" Secs", forState: .Normal)
        //call for a logic to handle the situation that M is 0
        btnLabelDelayToOff.setTitle(String(config.delMValue)+" M "+String(config.delSValue)+" S", forState: .Normal)
        
        btnLabelMaxDimming.setTitle(String(config.maxDimValue)+" %", forState: .Normal)
        btnLabelMinDimming.setTitle(String(config.minDimValue)+" %", forState: .Normal)
        btnLabelSensitivity.setTitle(String(config.sensValue)+" %", forState: .Normal)
        //todo @yuchao make it enable or disable
        btnLabelALS.setTitle(String(config.alsValue), forState: .Normal)
        
    }
    
    
    
    @IBAction func btnDetailSetting(sender: UIButton!) {
        print("clicked")
        performSegueWithIdentifier("detailSettingSegue", sender: sender)
        
    }
    
    
    @IBAction func sendBtn(sender: UIButton) {
        
        self.operations.loadingBuffers(node, command: self.operations.test())
        //to send all the commands
        //self.operations.excuteQueue(node, settings: self.operations.processQueue(self.settings))
        //todo @yuchao set maximum volume of output audio
        node.volume = 1
        node.play()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailSettingSegue" {
            
            let detailSettingViewController = segue.destinationViewController as! DetailSettingViewController
            
            switch sender!.tag {
            case 1:
                detailSettingViewController.type = Configuration.settingTypes.rampUP
            case 2:
                detailSettingViewController.type = Configuration.settingTypes.delayToOff
            case 3:
                detailSettingViewController.type = Configuration.settingTypes.rampDown
            case 4:
                detailSettingViewController.type = Configuration.settingTypes.maxDimming
            case 5:
                detailSettingViewController.type = Configuration.settingTypes.minDimming
            case 6:
                detailSettingViewController.type = Configuration.settingTypes.sensitivity
            case 7:
                detailSettingViewController.type = Configuration.settingTypes.lightSensor
                
            default:
                detailSettingViewController.type = Configuration.settingTypes.other
            }
            
            detailSettingViewController.delegate = self
            detailSettingViewController.settings = self.settings
        }
    }
    
    func updateSettings(setting: Configuration) {
        self.settings = setting
        print(settings.ruValue)
        
        self.viewDidLoad()
    }

}

