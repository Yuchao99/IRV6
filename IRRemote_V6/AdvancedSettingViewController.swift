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
class AdvancedSettingViewController: UIViewController,UINavigationControllerDelegate,UITextFieldDelegate {

    @IBOutlet weak var textDiff: UITextField!
    @IBOutlet weak var textMinSlope: UITextField!
    @IBOutlet weak var textMaxSlope: UITextField!
    @IBOutlet weak var textKeyMod: UITextField!


    
    
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
        textDiff.delegate = self
        textMinSlope.delegate = self
        textMaxSlope.delegate = self
        textKeyMod.delegate = self
        
        
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
        
        textDiff.text = String(settings.diffValue)
        textMinSlope.text = String(settings.minSlopeValue)
        textMaxSlope.text = String(settings.maxSlopeValue)
        textKeyMod.text = String(settings.keyModValue)
        
    }
    
    @IBAction func btnSendAction(sender: AnyObject) {
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        //todo check overlapping, then add scrollable view and make view shift
        
    }
    override func didMoveToParentViewController(parent: UIViewController?) {
        if parent == nil{
            print("back to parent")
            self.adDelegate.updateAdValue(self.settings) 
        }
    }
}