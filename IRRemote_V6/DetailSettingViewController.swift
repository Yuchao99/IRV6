//
//  DetailSettingViewController.swift
//  IRRemote_V6
//
//  Created by Yuchao Chen on 5/5/16.
//  Copyright © 2016 Yuchao Chen. All rights reserved.
//

import UIKit
import AVFoundation


protocol unwindValue {
    func updateSettings(setting: Configuration)
}

class DetailSettingViewController: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate {
    
    //declare all the UI components
    
    @IBOutlet weak var ScrollView: UIScrollView!
    
    @IBOutlet weak var labelMainTitle: UILabel!
    @IBOutlet weak var labelSubtitle: UILabel!
    @IBOutlet weak var sliderMain: UISlider!
    @IBOutlet weak var btnLabelValue: UIButton!
    @IBOutlet weak var labelUnitMark: UILabel!
    @IBOutlet weak var btnLabelSend: UIButton!
    @IBOutlet weak var sliderSub: UISlider!
    @IBOutlet weak var btnLabelValueSub: UIButton!
    @IBOutlet weak var labelUnitMarkSub: UILabel!
    @IBOutlet weak var textValue: UITextField!
    @IBOutlet weak var textValueSub: UITextField!
    @IBOutlet weak var btnLabelEnable: UIButton!
    
    
    
    var settings = Configuration()
    var type =   Configuration.settingTypes()
    var operation: Model!
    var engine: AVAudioEngine!
    var node: Protocal!
    var value: Int!
    var valueSub: Int!
    var maxValue: Int!
    var delegate: unwindValue!
    
    let alertSize = UIAlertController(title: nil, message: "Error, input number exceeds range", preferredStyle: .Alert)
    let alertNil = UIAlertController(title: nil, message: "Error, please input a valid number", preferredStyle: .Alert)
    let alertHeadphone = UIAlertController(title: nil, message: "Please connect RAB fixture to use the app", preferredStyle: .Alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingSetting()
        print("fllowed byh the name of this profile")
        print(self.settings.name)
        
        navigationController?.delegate = self
        
        textValue.delegate = self
        textValueSub.delegate = self
        
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
        alertSize.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
        alertNil.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
        alertHeadphone.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
        
    }

    override func viewWillAppear(animated: Bool) {
        //todo @yuchao make Subs also center at begin and add animation to right
        if self.type == .delayToOff {
            
            let xPosition = btnLabelValue.frame.origin.x - 100
            let yBtnValue = btnLabelValue.frame.origin.y
            let yLabelMark = labelUnitMark.frame.origin.y
            
            let heightBtnValue = btnLabelValue.frame.size.height
            let widthBtnValue = btnLabelValue.frame.size.width
            
            let heightLabelMark = labelUnitMark.frame.size.height
            let widthLabelMark = labelUnitMark.frame.size.width
            
            UIView.animateWithDuration(1.0, animations: {
                self.btnLabelValue.frame = CGRectMake(xPosition, yBtnValue, widthBtnValue, heightBtnValue)
                self.labelUnitMark.frame = CGRectMake(xPosition, yLabelMark, widthLabelMark, heightLabelMark)
                self.textValue.frame = CGRectMake(xPosition, yBtnValue, widthBtnValue, heightBtnValue)
                self.btnLabelValueSub.alpha = 1.0
                self.labelUnitMarkSub.alpha = 1.0
                
            })
            
            self.btnLabelValue.transform = CGAffineTransformTranslate(self.btnLabelValue.transform,  -100.0, 0.0)
            self.labelUnitMark.transform = CGAffineTransformTranslate(self.labelUnitMark.transform, -100.0, 0.0)
            self.textValue.transform = CGAffineTransformTranslate(self.textValue.transform, -100.0, 0.0)
        }
        //hints: absolut position
        // btnLabelValue.frame.origin = CGPoint(x:250, y:250)
    }
    
    override func viewDidAppear(animated: Bool) {
        let route = AVAudioSession.sharedInstance().currentRoute
        
        for port in route.outputs {
            if port.portType == AVAudioSessionPortHeadphones {
                print("there is headphone")
            }else{
                print("ther e is no headphone")
                
                self.presentViewController(alertHeadphone, animated: true, completion: nil)
            }
        }
    }
    override func viewDidLayoutSubviews() {
        let border = CALayer()
        let borderSub = CALayer()
        
        let width = CGFloat(2.0)
        
        border.borderColor = UIColor.redColor().CGColor
        border.frame = CGRect(x: 0, y: textValue.frame.size.height - width, width:  textValue.frame.size.width, height: textValue.frame.size.height)
        border.borderWidth = width
        
        borderSub.borderColor = UIColor.redColor().CGColor
        borderSub.frame = CGRect(x: 0, y: textValueSub.frame.size.height - width, width:  textValueSub.frame.size.width, height: textValueSub.frame.size.height)
        borderSub.borderWidth = width
        
        textValue.layer.addSublayer(border)
        textValue.layer.masksToBounds = true
        
        textValueSub.layer.addSublayer(borderSub)
        textValueSub.layer.masksToBounds = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadingSetting(){
        
        sliderSub.hidden = true
        btnLabelValueSub.hidden = true
        labelUnitMarkSub.hidden = true
        textValue.hidden = true
        textValueSub.hidden = true
        btnLabelEnable.hidden = true
        
        btnLabelValueSub.alpha = 0
        labelUnitMarkSub.alpha = 0
        
        switch type {
        case .rampUP:
            labelMainTitle.text = "Ramp Up Setting"
            labelSubtitle.text = "Select Ramp Up Value"
            value = settings.ruValue
            btnLabelValue.setTitle(String(value), forState: .Normal)
            labelUnitMark.text = "Seconds"
            maxValue = 60
            textValue.text = String(value)
            
        case .delayToOff:
            labelMainTitle.text = "Delay To Off Setting"
            labelSubtitle.text = "Select Delay To Off Value"
            value = settings.delMValue
            valueSub = settings.delSValue
            btnLabelValue.setTitle(String(value), forState: .Normal)
            btnLabelValueSub.setTitle(String(valueSub), forState: .Normal)
            maxValue = 60
            sliderSub.setValue(Float(Float(valueSub)/100), animated: true)
            sliderSub.hidden = false
            btnLabelValueSub.hidden = false
            labelUnitMarkSub.hidden = false
            labelUnitMark.text = "Mins"
            labelUnitMarkSub.text = "Seconds"
            textValue.text = String(value)
            textValueSub.text = String(valueSub)
            
        case .rampDown:
            labelMainTitle.text = "Ramp Down Setting"
            labelSubtitle.text = "Select Ramp Down Value"
            value = settings.rdValue
            btnLabelValue.setTitle(String(value), forState: .Normal)
            labelUnitMark.text = "Seconds"
            maxValue = 60
            textValue.text = String(value)
            
        case .maxDimming:
            labelMainTitle.text = "Max Dimming Setting"
            labelSubtitle.text = "Select Max Dimming Value"
            value = settings.maxDimValue
            btnLabelValue.setTitle(String(value), forState: .Normal)
            labelUnitMark.text = "%"
            maxValue = 100
            textValue.text = String(value)
        
        case .minDimming:
            labelMainTitle.text = "Min Dimming Setting"
            labelSubtitle.text = "Select Min Dimming Value"
            value = settings.minDimValue
            btnLabelValue.setTitle(String(value), forState: .Normal)
            maxValue = 100
            textValue.text = String(value)
            
        case .sensitivity:
            labelMainTitle.text = "Sensitivity Setting"
            labelSubtitle.text = "Select Sensitivity Value"
            value = settings.sensValue
            btnLabelValue.setTitle(String(value), forState: .Normal)
            labelUnitMark.text = "%"
            maxValue = 100
            textValue.text = String(value)
        
        case .lightSensor:
            labelMainTitle.text = "Light Sensor Setting"
            labelSubtitle.text = "Select Light Sensor Value"
            value = settings.maxLuxValue
            btnLabelValue.setTitle(String(value), forState: .Normal)
            maxValue = 100
            labelUnitMark.text = "fc"
            textValue.text = String(value)
            btnLabelEnable.hidden = false
            if settings.alsValue == true{
                btnLabelEnable.setTitle("Light Sensing is Enabled", forState: .Normal)
                btnLabelSend.enabled = true
            }else{
                btnLabelEnable.setTitle("Light Sensing is Disabled", forState: .Normal)
                btnLabelSend.enabled = false
            }
        default:
            labelMainTitle.text = "Setting"
            labelSubtitle.text = "Select Value"
            value = 0
            btnLabelValue.setTitle("0", forState: .Normal)
            labelUnitMark.text = "NULL"
            maxValue = 100
            textValue.text = ""
        }
        

        sliderMain.setValue(Float(Float(value) / 100), animated: true)
        
    }
    
    @IBAction func sliderMainAction(sender: AnyObject) {
        
        btnLabelValue.setTitle(String(Int(sliderMain.value * Float(maxValue) )), forState: .Normal)
        
        switch type {
        case .rampUP:
            settings.ruValue = Int(sliderMain.value * Float(maxValue) )
            textValue.text = String(Int(sliderMain.value * Float(maxValue)))
        
        case .rampDown:
            settings.rdValue = Int(sliderMain.value * Float(maxValue) )
            textValue.text = String(Int(sliderMain.value * Float(maxValue)))
            
        case .maxDimming:
            settings.maxDimValue = Int(sliderMain.value * Float(maxValue) )
            textValue.text = String(Int(sliderMain.value * Float(maxValue)))
            
        case .minDimming:
            settings.minDimValue = Int(sliderMain.value * Float(maxValue) )
            textValue.text = String(Int(sliderMain.value * Float(maxValue)))
        
        case .sensitivity:
            settings.sensValue = Int(sliderMain.value * Float(maxValue) )
            textValue.text = String(Int(sliderMain.value * Float(maxValue)))
        
        case .delayToOff:
            settings.delMValue = Int(sliderMain.value * Float(maxValue))
            textValue.text = String(Int(sliderMain.value * Float(maxValue)))
          
        case .lightSensor:
            settings.maxLuxValue = Int(sliderMain.value * Float(maxValue))
            textValue.text = String(Int(sliderMain.value * Float(maxValue)))
        
        default:
            print("no value is changed")
        }
    }
    
    @IBAction func sliderSubAction(sender: AnyObject) {
        
        switch type {
            
        case .delayToOff:
            btnLabelValueSub.setTitle(String(Int(sliderSub.value * Float(maxValue) )), forState: .Normal)
            settings.delSValue = Int(sliderSub.value * Float(maxValue))
            textValueSub.text = String(Int(sliderSub.value * Float(maxValue)))
        
        default:
            print("sub slider error")
        }
        
    }
    
    @IBAction func btnValue(sender: AnyObject) {
        
        textValue.hidden = false
        btnLabelValue.hidden = true
        
    
    }
    
    @IBAction func btnValueSub(sender: AnyObject) {
        
        textValueSub.hidden = false
        btnLabelValueSub.hidden = true
    }
    
    @IBAction func btnSend(sender: AnyObject) {
        
        var stream: String!
        
        switch self.type {
        case .rampUP:
            stream = operation.processDetailCommand(Configuration.settingTypes.rampUP.value, value: self.settings.ruValue)
        case .rampDown:
            stream = operation.processDetailCommand(Configuration.settingTypes.rampDown.value, value: self.settings.rdValue)
        case .maxDimming:
            stream = operation.processDetailCommand(Configuration.settingTypes.maxDimming.value, value: self.settings.maxDimValue)
        case .minDimming:
            stream = operation.processDetailCommand(Configuration.settingTypes.minDimming.value, value: self.settings.minDimValue)
        case .sensitivity:
            stream = operation.processDetailCommand(Configuration.settingTypes.sensitivity.value, value: self.settings.sensValue)
        case .delayToOff:
            if settings.delMValue >= 4{
                stream = operation.processDetailCommand(Configuration.settingTypes.delayToOffM.value, value: self.settings.delMValue)
            }else{
                stream = operation.processDetailCommand(Configuration.settingTypes.delayToOffS.value, value: self.settings.delMValue * 60 + self.settings.delSValue)
            }
            
        case .lightSensor:
            stream = operation.processDetailCommand(Configuration.settingTypes.maxLuxValue.value, value: self.settings.maxLuxValue)
            
        default:
            print("error to create signal")
            stream = ""
        }
        self.sendingStatus(false)
        self.operation.loadingBuffers(node, command: stream)
        node.play()
        self.operation.delay(400){
            self.sendingStatus(true)
        }
        
    }
    
    @IBAction func btnEnableAction(sender: AnyObject) {
        settings.alsValue = !settings.alsValue
        btnLabelSend.enabled = !btnLabelSend.enabled
        
        if settings.alsValue == true {
            btnLabelEnable.setTitle("Light Sensing is Enabled", forState: .Normal)
        }else{
            btnLabelEnable.setTitle("Light Sensing is Disabled", forState: .Normal)
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
        
        return string == filtered && newLength <= 3
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        if Int(textField.text!) == nil{
            
            self.presentViewController(alertNil, animated: true, completion: nil)
            print("strep 1")
            if textField == textValue{
                textValue.text = String(self.value)
                sliderMain.setValue(Float(Float(self.value) / 100), animated: true)
                 print("strep 2")
            }else{
                textValueSub.text = String(self.valueSub)
                sliderSub.setValue(Float(Float(self.valueSub) / 100), animated: true)
                 print("strep 3")
            }
             print("strep 4")
            
        }else if Int(textField.text!)! > self.maxValue{
            
            
            self.presentViewController(alertSize, animated: true, completion: nil)
            
            if textField == textValue{
                textValue.text = String(self.value)
                sliderMain.setValue(Float(Float(self.value) / 100), animated: true)
            }else{
                textValueSub.text = String(self.valueSub)
                sliderSub.setValue(Float(Float(self.valueSub) / 100), animated: true)
            }
            
            
        }else{
            
            
            
            if textField == textValue {
                
                switch type {
                case .rampUP:
                    settings.ruValue = Int(textValue.text!)
                    
                case .rampDown:
                    settings.rdValue = Int(textValue.text!)
                    
                case .maxDimming:
                    settings.maxDimValue = Int(textValue.text!)
                    
                case .minDimming:
                    settings.minDimValue = Int(textValue.text!)
                    
                case .sensitivity:
                    settings.sensValue = Int(textValue.text!)
                    
                case .delayToOff:
                    settings.delMValue = Int(textValue.text!)
                    
                case .lightSensor:
                    settings.maxLuxValue = Int(textValue.text!)
                    
                default:
                    print("no value is changed")
                }
                self.sliderMain.setValue(Float(Float(textValue.text!)! / 100), animated: true)
                
            }else{
                settings.delSValue = Int(textValueSub.text!)
                self.sliderSub.setValue(Float(Float(textValueSub.text!)! / 100), animated: true)
            }
        }
        
        ScrollView.setContentOffset(CGPointMake(0, 0), animated: true)
        navigationController?.navigationBar.userInteractionEnabled = true

    }
    
    func sendingStatus(enable: Bool){
        self.btnLabelSend.enabled = enable;
    }
    
    override func didMoveToParentViewController(parent: UIViewController?) {
        
        if parent == nil {
            print("back to parent view")
            self.delegate.updateSettings(self.settings)
            
        }
    }
    
    

}
