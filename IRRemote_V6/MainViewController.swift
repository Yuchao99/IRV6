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
    
    var operations = Model()
    var engine: AVAudioEngine!
    var node: Protocal!

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

    
    @IBAction func sendBtn(sender: UIButton) {
        
        self.operations.loadingBuffers(node, command: self.operations.test())
        node.play()
    }

}

