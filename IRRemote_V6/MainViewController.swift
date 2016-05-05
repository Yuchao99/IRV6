//
//  ViewController.swift
//  IRRemote_V6
//
//  Created by Yuchao Chen on 4/29/16.
//  Copyright © 2016 Yuchao Chen. All rights reserved.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController {
    
    //init all the business parameters
    var operations = Model()
    var settings = Configuration()
    var engine: AVAudioEngine!
    var node: Protocal!

    //declare all the UI components
    @IBOutlet weak var labelRampUp: UILabel!
    @IBOutlet weak var labelDelayToOff: UILabel!
    @IBOutlet weak var labelRampDown: UILabel!
    
    
    @IBOutlet weak var btnLabelRampUp: UIButton!
    @IBOutlet weak var btnLabelDelayToOff: UIButton!
    @IBOutlet weak var btnLabelRampDown: UIButton!
    

    
    
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
        btnLabelDelayToOff.setTitle(String(config.delM)+" M "+String(config.delS)+" S", forState: .Normal)
    }
    
    
    
    @IBAction func btnDetailSetting(sender: UIButton!) {
        print("clicked")
        performSegueWithIdentifier("detailSettingSegue", sender: sender)
        
    }
    
    @IBAction func sendBtn(sender: UIButton) {
        
        self.operations.loadingBuffers(node, command: self.operations.test())
        //to send all the commands
        //self.operations.excuteQueue(node, settings: self.operations.processQueue(self.settings))
        node.play()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailSettingSegue" {
            var detailSettingViewController = segue.destinationViewController as! DetailSettingViewController
            
            
            switch sender!.tag {
            case 1:
                detailSettingViewController.type = Configuration.settingTypes.rampUP
            case 2:
                detailSettingViewController.type = Configuration.settingTypes.delayToOff

            case 3:
                detailSettingViewController.type = Configuration.settingTypes.rampDown

            default:
                detailSettingViewController.type = Configuration.settingTypes.other
            }
            
            detailSettingViewController.settings = self.settings
        }
    }

}
