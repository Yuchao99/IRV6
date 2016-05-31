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
    
    @IBOutlet weak var ScrollView: UIScrollView!

    @IBOutlet weak var textDiff: UITextField!
    @IBOutlet weak var textMinSlope: UITextField!
    @IBOutlet weak var textMaxSlope: UITextField!
    @IBOutlet weak var textKeyMod: UITextField!

    @IBOutlet weak var btnLabelDiff: UIButton!
    @IBOutlet weak var btnLabelMinSlope: UIButton!
    @IBOutlet weak var btnLabelMaxSlope: UIButton!
    @IBOutlet weak var btnLabelKeyMod: UIButton!
    @IBOutlet weak var btnLabelSendAll: UIButton!
    
    var settings = Configuration()
    var type =   Configuration.settingTypes()
    var operation: Model!
    var engine: AVAudioEngine!
    var node: Protocal!
    var adDelegate: unwindAdValue!
    
    let alertSize = UIAlertController(title: nil, message: "Error, input number exceeds range", preferredStyle: .Alert)
    let alertNil = UIAlertController(title: nil, message: "Error, please input a valid number", preferredStyle: .Alert)
    
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
        
        //for error talorence
        alertSize.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
        alertNil.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
    }

    override func viewDidLayoutSubviews() {
        let border = CALayer()
        let border2 = CALayer()
        let border3 = CALayer()
        let border4 = CALayer()
        let width = CGFloat(2.0)
        
        
        border.borderColor = UIColor.redColor().CGColor
        border.frame = CGRect(x: 0, y: textDiff.frame.size.height - width, width:  textDiff.frame.size.width, height: textDiff.frame.size.height)
        border.borderWidth = width
        
        border2.borderColor = UIColor.redColor().CGColor
        border2.frame = CGRect(x: 0, y: textDiff.frame.size.height - width, width:  textDiff.frame.size.width, height: textDiff.frame.size.height)
        border2.borderWidth = width
        
        border3.borderColor = UIColor.redColor().CGColor
        border3.frame = CGRect(x: 0, y: textDiff.frame.size.height - width, width:  textDiff.frame.size.width, height: textDiff.frame.size.height)
        border3.borderWidth = width
        
        border4.borderColor = UIColor.redColor().CGColor
        border4.frame = CGRect(x: 0, y: textDiff.frame.size.height - width, width:  textDiff.frame.size.width, height: textDiff.frame.size.height)
        border4.borderWidth = width
        
        
        textDiff.layer.addSublayer(border)
        textDiff.layer.masksToBounds = true
        
        textMinSlope.layer.addSublayer(border2)
        textMinSlope.layer.masksToBounds = true
        
        textMaxSlope.layer.addSublayer(border3)
        textMaxSlope.layer.masksToBounds = true
        
        textKeyMod.layer.addSublayer(border4)
        textKeyMod.layer.masksToBounds = true
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
    
    @IBAction func btnSendAction(sender: UIButton!) {
        
        view.endEditing(true)
        
        var stream: String!
        
        switch sender!.tag {
        case 1:
            stream = operation.processAdCommand(Configuration.settingTypes.diff.value, value: Int(textDiff.text!)!)
        case 2:
            stream = operation.processAdCommand(Configuration.settingTypes.minSlope.value, value: Int(textMinSlope.text!)!)
        case 3:
            stream = operation.processAdCommand(Configuration.settingTypes.maxSlope.value, value: Int(textMaxSlope.text!)!)
        case 4:
            stream = operation.processAdCommand(Configuration.settingTypes.keyMod.value, value: Int(textKeyMod.text!)!)
        default:
            stream = ""
            
        }
        
        self.operation.loadingBuffers(node, command: stream)
        self.sendingStatus(false)
        node.play()
        self.operation.delay(400) { 
            self.sendingStatus(true)
        }
    }
    
    @IBAction func btnSendAllAdSettings(sender: AnyObject) {
        
        var stream = [String]()
        
        stream.append(operation.processAdCommand(Configuration.settingTypes.diff.value, value: Int(textDiff.text!)!))
        stream.append(operation.processAdCommand(Configuration.settingTypes.minSlope.value, value: Int(textMinSlope.text!)!))
        stream.append(operation.processAdCommand(Configuration.settingTypes.maxSlope.value, value: Int(textMaxSlope.text!)!))
        stream.append(operation.processAdCommand(Configuration.settingTypes.keyMod.value, value: Int(textKeyMod.text!)!))
        
        for i in stream{
            self.operation.loadingBuffers(node, command: i)
            self.sendingStatus(false)
            node.play()
            self.operation.delay(400, closure: { 
                self.sendingStatus(true)
            })
        }
        
    }
    
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        ScrollView.setContentOffset(CGPointMake(0, 250), animated: true)
        textField.becomeFirstResponder()
        
        textField.selectedTextRange = textField.textRangeFromPosition(textField.beginningOfDocument, toPosition: textField.endOfDocument)
        
        navigationController?.navigationBar.userInteractionEnabled = false
        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let inverseSet = NSCharacterSet(charactersInString:"0123456789").invertedSet
        
        let components = string.componentsSeparatedByCharactersInSet(inverseSet)
        
        let filtered = components.joinWithSeparator("")
        
        let newLength = textField.text!.characters.count + string.characters.count - range.length
        
        return string == filtered && newLength <= 5
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        if Int(textField.text!) == nil{
            
            self.presentViewController(alertNil, animated: true, completion: nil)
            
            switch textField{
            case textDiff:
                self.textDiff.text = String(self.settings.diffValue)
            case textMinSlope:
                self.textMinSlope.text = String(self.settings.minSlopeValue)
            case textMaxSlope:
                self.textMaxSlope.text = String(self.settings.maxSlopeValue)
            case textKeyMod:
                self.textKeyMod.text = String(self.settings.keyModValue)
            default:
                print("input exceeds range error to reload settings")
            }
            
        }else if Int(textField.text!)! > 65535{
            
            self.presentViewController(alertSize, animated: true, completion: nil)
            
            switch textField{
            case textDiff:
                self.textDiff.text = String(self.settings.diffValue)
            case textMinSlope:
                self.textMinSlope.text = String(self.settings.minSlopeValue)
            case textMaxSlope:
                self.textMaxSlope.text = String(self.settings.maxSlopeValue)
            case textKeyMod:
                self.textKeyMod.text = String(self.settings.keyModValue)
            default:
                print("input exceeds range error to reload settings")
            }
            
        }else{
            //todo check overlapping, then add scrollable view and make view shift
            switch textField {
                case textDiff:
                    self.settings.diffValue = Int(textDiff.text!)
                case textMinSlope:
                    self.settings.minSlopeValue = Int(textMinSlope.text!)
                case textMaxSlope:
                    self.settings.maxSlopeValue = Int(textMaxSlope.text!)
                case textKeyMod:
                    self.settings.keyModValue = Int(textKeyMod.text!)
                default:
                    print("error happens and close the keyboard outsides")
            }
        }

        ScrollView.setContentOffset(CGPointMake(0, 0), animated: true)
        navigationController?.navigationBar.userInteractionEnabled = true
    }
    
    func sendingStatus(enable: Bool){
        self.btnLabelDiff.enabled = enable
        self.btnLabelKeyMod.enabled = enable
        self.btnLabelMaxSlope.enabled = enable
        self.btnLabelMinSlope.enabled = enable
        self.btnLabelSendAll.enabled = enable
    }
    
    override func didMoveToParentViewController(parent: UIViewController?) {
        if parent == nil{
            print("back to parent")
            self.adDelegate.updateAdValue(self.settings) 
        }
    }
}
