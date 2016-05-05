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
        
        //engine start
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func btnDetailSetting(sender: AnyObject) {
        print("clicked")
        performSegueWithIdentifier("detailSettingSegue", sender: self)
    }
    
    @IBAction func sendBtn(sender: UIButton) {
        
        self.operations.loadingBuffers(node, command: self.operations.test())
        //to send all the commands
        //self.operations.excuteQueue(node, settings: self.operations.processQueue(self.settings))
        node.play()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }

}

