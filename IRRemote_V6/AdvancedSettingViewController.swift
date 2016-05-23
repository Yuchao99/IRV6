//
//  AdvancedSettingViewController.swift
//  IRRemote_V6
//
//  Created by Yuchao Chen on 5/22/16.
//  Copyright © 2016 Yuchao Chen. All rights reserved.
//

import UIKit
import AVFoundation

protocol unwindAdValue {
    func updateAdValue(setting: Configuration)
}
class AdvancedSettingViewController: UIViewController,UINavigationControllerDelegate {

    
    var settings = Configuration()
    var type =   Configuration.settingTypes()
    var operation: Model!
    var engine: AVAudioEngine!
    var node: Protocal!
    var adDelegate: unwindAdValue!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadingSetting()
        
        navigationController?.delegate = self
        
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
        
    }
    
    override func didMoveToParentViewController(parent: UIViewController?) {
        if parent == nil{
            print("back to parent")
            self.adDelegate.updateAdValue(self.settings) 
        }
    }
}
