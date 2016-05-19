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

class DetailSettingViewController: UIViewController, UINavigationControllerDelegate {

    //declare all the UI components
    @IBOutlet weak var labelMainTitle: UILabel!
    @IBOutlet weak var labelSubtitle: UILabel!
    @IBOutlet weak var sliderMain: UISlider!
    @IBOutlet weak var btnLabelValue: UIButton!
    @IBOutlet weak var labelUnitMark: UILabel!
    @IBOutlet weak var btnLabelSend: UIButton!
    @IBOutlet weak var sliderSub: UISlider!
    @IBOutlet weak var btnLabelValueSub: UIButton!
    @IBOutlet weak var labelUnitMarkSub: UILabel!
    
    
    
    var settings = Configuration()
    var type =   Configuration.settingTypes()
    var operation: Model!
    var engine: AVAudioEngine!
    var node: Protocal!
    var value: Int!
    var valueSub: Int!
    var maxValue: Int!
    var delegate: unwindValue!
    
    
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

    override func viewWillAppear(animated: Bool) {
        //todo @yuchao make Subs also center at begin and add animation to right
        if self.type == .delayToOff || self.type == .lightSensor{
            
            let xPosition = btnLabelValue.frame.origin.x - 50
            let yBtnValue = btnLabelValue.frame.origin.y
            let yLabelMark = labelUnitMark.frame.origin.y
            
            let heightBtnValue = btnLabelValue.frame.size.height
            let widthBtnValue = btnLabelValue.frame.size.width
            
            let heightLabelMark = labelUnitMark.frame.size.height
            let widthLabelMark = labelUnitMark.frame.size.width
            
            UIView.animateWithDuration(1.0, animations: {
                self.btnLabelValue.frame = CGRectMake(xPosition, yBtnValue, widthBtnValue, heightBtnValue)
                self.labelUnitMark.frame = CGRectMake(xPosition, yLabelMark, widthLabelMark, heightLabelMark)
                self.btnLabelValueSub.alpha = 1.0
                self.labelUnitMarkSub.alpha = 1.0
            })
            
            self.btnLabelValue.transform = CGAffineTransformTranslate(self.btnLabelValue.transform,  -50.0, 0.0)
            self.labelUnitMark.transform = CGAffineTransformTranslate(self.labelUnitMark.transform, -50.0, 0.0)
            
        }
        //hints: absolut position
        // btnLabelValue.frame.origin = CGPoint(x:250, y:250)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadingSetting(){
        
        sliderSub.hidden = true
        btnLabelValueSub.hidden = true
        labelUnitMarkSub.hidden = true
        
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
            
        case .delayToOff:
            labelMainTitle.text = "Delay To Off Setting"
            labelSubtitle.text = "Select Delay To Off Value"
            value = settings.delMValue
            valueSub = settings.delSValue
            btnLabelValue.setTitle(String(value), forState: .Normal)
            btnLabelValueSub.setTitle(String(valueSub), forState: .Normal)
            maxValue = 60
            sliderSub.hidden = false
            btnLabelValueSub.hidden = false
            labelUnitMarkSub.hidden = false
            labelUnitMark.text = "Mins"
            labelUnitMarkSub.text = "Seconds"
            
        case .rampDown:
            labelMainTitle.text = "Ramp Down Setting"
            labelSubtitle.text = "Select Ramp Down Value"
            value = settings.rdValue
            btnLabelValue.setTitle(String(value), forState: .Normal)
            labelUnitMark.text = "Seconds"
            maxValue = 60
            
        case .maxDimming:
            labelMainTitle.text = "Max Dimming Setting"
            labelSubtitle.text = "Select Max Dimming Value"
            value = settings.maxDimValue
            btnLabelValue.setTitle(String(value), forState: .Normal)
            labelUnitMark.text = "%"
            maxValue = 100
        
        case .minDimming:
            labelMainTitle.text = "Min Dimming Setting"
            labelSubtitle.text = "Select Min Dimming Value"
            value = settings.minDimValue
            btnLabelValue.setTitle(String(value), forState: .Normal)
            maxValue = 100
            
        case .sensitivity:
            labelMainTitle.text = "Sensitivity Setting"
            labelSubtitle.text = "Select Sensitivity Value"
            value = settings.sensValue
            btnLabelValue.setTitle(String(value), forState: .Normal)
            labelUnitMark.text = "%"
            maxValue = 100
        
        case .lightSensor:
            labelMainTitle.text = "Light Sensor Setting"
            labelSubtitle.text = "Select Light Sensor Value"
            value = settings.maxLuxValue
            valueSub = settings.minLuxValue
            btnLabelValue.setTitle(String(value), forState: .Normal)
            btnLabelValueSub.setTitle(String(valueSub), forState: .Normal)
            maxValue = 100
            sliderSub.hidden = false
            btnLabelValueSub.hidden = false
            labelUnitMarkSub.hidden = false
            labelUnitMark.text = "%"
            labelUnitMarkSub.text = "%"
            
        default:
            labelMainTitle.text = "Setting"
            labelSubtitle.text = "Select Value"
            value = 0
            btnLabelValue.setTitle("0", forState: .Normal)
            labelUnitMark.text = "NULL"
            maxValue = 100
        }
        

        sliderMain.setValue(Float(Float(value) / 100), animated: true)
    }
    
    @IBAction func sliderMainAction(sender: AnyObject) {
        
        btnLabelValue.setTitle(String(Int(sliderMain.value * Float(maxValue) )), forState: .Normal)
        
        switch type {
        case .rampUP:
            settings.ruValue = Int(sliderMain.value * Float(maxValue) )
        
        case .rampDown:
            settings.rdValue = Int(sliderMain.value * Float(maxValue) )
            
        case .maxDimming:
            settings.maxDimValue = Int(sliderMain.value * Float(maxValue) )
            
        case .minDimming:
            settings.minDimValue = Int(sliderMain.value * Float(maxValue) )
        
        case .sensitivity:
            settings.sensValue = Int(sliderMain.value * Float(maxValue) )
        
        case .delayToOff:
            settings.delMValue = Int(sliderMain.value * Float(maxValue))
          
        case .lightSensor:
            settings.maxLuxValue = Int(sliderMain.value * Float(maxValue))
        
        default:
            print("no value is changed")
        }
    }
    
    @IBAction func sliderSubAction(sender: AnyObject) {
        
        switch type {
        case .delayToOff:
            btnLabelValueSub.setTitle(String(Int(sliderSub.value * Float(maxValue) )), forState: .Normal)
            settings.delSValue = Int(sliderSub.value * Float(maxValue))
            
        case .lightSensor:
            btnLabelValueSub.setTitle(String(Int(sliderSub.value * Float(maxValue) )), forState: .Normal)
            settings.minLuxValue = Int(sliderSub.value * Float(maxValue))
        
        default:
            print("sub slider error")
        }
        
    }
    
    @IBAction func btnValue(sender: AnyObject) {

    
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
        default:
            print("error to create signal")
            stream = ""
        }
        
        self.operation.loadingBuffers(node, command: stream)
        node.play()
    }
    

    
    override func didMoveToParentViewController(parent: UIViewController?) {
        
        if parent == nil {
            print("back to parent view")
            self.delegate.updateSettings(self.settings)
            
        }

        
    }
    


}
