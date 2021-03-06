//
//  ViewController.swift
//  IRRemote_V6
//
//  Created by Yuchao Chen on 4/29/16.
//  Copyright © 2016 Yuchao Chen. All rights reserved.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController, UIPopoverPresentationControllerDelegate, UITextFieldDelegate, unwindValue, unwindItems, unwindAdValue, unwindProfile{
    
    //database
    var profiles = [Configuration]()
    var profileIndex = Int(0)
    let defaults = NSUserDefaults.standardUserDefaults()

    
    //init all the business parameters
    var operations = Model()
    var settings = Configuration()
    var engine: AVAudioEngine!
    var node: Protocal!
    
    let alertHeadphone = UIAlertController(title: nil, message: "Please connect RAB fixture to use the app", preferredStyle: .Alert)
    let alertSending = UIAlertController(title: nil, message: "Sending\n\n\n\n", preferredStyle: UIAlertControllerStyle.Alert)
    
    let spinnerIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    
    

    //declare all the UI components
    @IBOutlet weak var labelRampUp: UILabel!
    @IBOutlet weak var labelDelayToOff: UILabel!
    @IBOutlet weak var labelRampDown: UILabel!
    @IBOutlet weak var labelMaxDimming: UILabel!
    @IBOutlet weak var labelMinDimming: UILabel!
    @IBOutlet weak var labelSensitivity: UILabel!
    @IBOutlet weak var labelALS: UILabel!
    
    
    
    @IBOutlet weak var btnLabelRampUp: UIButton!
    @IBOutlet weak var btnLabelDelayToOff: UIButton!
    @IBOutlet weak var btnLabelRampDown: UIButton!
    @IBOutlet weak var btnLabelMaxDimming: UIButton!
    @IBOutlet weak var btnLabelMinDimming: UIButton!
    @IBOutlet weak var btnLabelSensitivity: UIButton!
    @IBOutlet weak var btnLabelALS: UIButton!
    @IBOutlet weak var btnLabelMenu: UIBarButtonItem!
    @IBOutlet weak var btnLabelProfile: UIButton!
    @IBOutlet weak var btnLabelSave: UIButton!
    @IBOutlet weak var btnLabelDelete: UIButton!
    @IBOutlet weak var btnLabelSendAll: UIButton!
    
    @IBOutlet weak var textProfile: UITextField!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if ((self.databaseRetrieveProfiles()) != nil) {
            print("retrieve success")
            self.profiles = self.databaseRetrieveProfiles()!
            self.profileIndex = self.databaseRetrieveIndex()
            self.settings = self.profiles[self.profileIndex]
            loadSetting(self.settings)
            
            self.editProfileMode(false)
            print("loading retrieved data into system")
            
        }else{
            self.profiles.append(self.settings)
            self.databaseSave(self.profiles, index: 0)
            loadSetting(settings)
            self.editProfileMode(false)
            print("retrieve failed, use default data")
        }
        
        textProfile.delegate = self
        
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
        
        
        alertHeadphone.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
        spinnerIndicator.center = CGPointMake(135.0, 100.5)
        spinnerIndicator.color = UIColor.blackColor()
        spinnerIndicator.startAnimating()
        alertSending.view.addSubview(spinnerIndicator)
        let aview = alertSending.view
        aview.alpha = 0.95
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func databaseRetrieveProfiles() -> [Configuration]?{
        if let rawData = self.defaults.objectForKey("profiles") as? NSData{
            let processedData = NSKeyedUnarchiver.unarchiveObjectWithData(rawData) as! [Configuration]
            self.profileIndex = self.defaults.objectForKey("profileIndex") as! Int
            print("retrieve data success")
            return processedData
        }else{
            print("retrieve data field")
            return nil
        }
    }
    
    func databaseRetrieveIndex() -> Int{
        if let index = self.defaults.objectForKey("profileIndex") as? Int{
            return index
        }else{
            return 0
        }
    }
    
    func databaseSave(data: AnyObject, index: Int){
        let processedData = NSKeyedArchiver.archivedDataWithRootObject(data)
        self.defaults.setObject(processedData, forKey: "profiles")
        self.defaults.setObject(index, forKey: "profileIndex")
        print("save profiles")
    }
    
    func databaseDelete(){
        
    }
    
    func loadSetting(config: Configuration){
        
        btnLabelRampUp.setTitle(String(config.ruValue)+" Secs", forState: .Normal)
        btnLabelRampDown.setTitle(String(config.rdValue)+" Secs", forState: .Normal)

        if config.delMValue == 0{
            btnLabelDelayToOff.setTitle(String(config.delSValue)+" Secs", forState: .Normal)
        }else{
            btnLabelDelayToOff.setTitle(String(config.delMValue)+" M "+String(config.delSValue)+" S", forState: .Normal)
        }
        
        
        btnLabelMaxDimming.setTitle(String(config.maxDimValue)+" %", forState: .Normal)
        btnLabelMinDimming.setTitle(String(config.minDimValue)+" %", forState: .Normal)
        btnLabelSensitivity.setTitle(String(config.sensValue)+" %", forState: .Normal)
        
        if config.alsValue == true {
            btnLabelALS.setTitle(String(config.maxLuxValue), forState: .Normal)
        }else{
            btnLabelALS.setTitle("DISABLED", forState: .Normal)
        }
        
        btnLabelProfile.setTitle((config.name), forState: .Normal)
        textProfile.text = config.name
        
        
    }
    
    
    
    @IBAction func btnDetailSetting(sender: UIButton!) {
        print("clicked")
        performSegueWithIdentifier("detailSettingSegue", sender: sender)
        
    }
    
    
    @IBAction func sendBtn(sender: UIButton) {
        btnLabelSendAll.enabled = false
        //self.presentViewController(alertSending, animated: false, completion: nil)
        self.excuteQueue(node, settings: self.operations.processQueue(self.settings))
        
        btnLabelSendAll.enabled = true
    }
    
    @IBAction func btnMenuAction(sender: AnyObject) {
    }
    
    @IBAction func btnProfilesAction(sender: AnyObject) {
        
    }
    
    @IBAction func btnProfileSave(sender: AnyObject) {
        
        
        if self.profiles.count == self.profileIndex{
            self.profiles.append(self.settings)
            self.databaseSave(self.profiles, index: self.profileIndex)
            print("save new file success")
        }else{
            self.profiles[self.profileIndex] = self.settings
            self.databaseSave(self.profiles, index: self.profileIndex)
            print("update profile success")
        }
        self.loadSetting(self.profiles[self.profileIndex])
        self.editProfileMode(false)
        print("save profiels success")
    }
    
    @IBAction func btnProfileDelete(sender: AnyObject) {
       
        if self.profileIndex ==  self.profiles.count{
            
            print("delete new file success")
        }else{
            self.profiles.removeAtIndex(self.profileIndex)
            
            print("delete file at index success")
        }
        self.profileIndex = 0
        self.loadSetting(self.profiles[self.profileIndex])
        
        self.databaseSave(self.profiles, index: self.profileIndex)
        self.editProfileMode(false)
    }
    
    //excute setting queue
    func excuteQueue(node: Protocal, settings: [String]){
        
        var delaytime = 12000.0
//        var delaytotal = 250.0 * (Double(settings.count) + 1)
//        self.operations.delay(delaytotal) { 
//            self.dismissViewControllerAnimated(true) {
//            }
//        }
        for setting: String in settings{
            
            self.operations.delay(delaytime){
                print("delay")
                self.operations.loadingBuffers(node, command: setting)
                node.volume = 1
                node.play()
            }
            delaytime = delaytime + 12000.0
        }
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

        }else if segue.identifier == "menuItemsSegue"{
            
            let menuBarViewController = segue.destinationViewController as! MenuBarViewController
            menuBarViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            menuBarViewController.popoverPresentationController!.delegate = self
            
            menuBarViewController.thisItem = self
            
        }else if segue.identifier == "advancedSettingSegue"{
            let advancedSettingViewController = segue.destinationViewController as! AdvancedSettingViewController
            advancedSettingViewController.settings = self.settings
            advancedSettingViewController.adDelegate = self
            
        }else if segue.identifier == "profileSeletSegue"{
        
            let profileSelectViewController = segue.destinationViewController as! ProfileViewController
            profileSelectViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            profileSelectViewController.popoverPresentationController!.delegate = self
            
            profileSelectViewController.thisNum = self
            
            var profileNameList = [String]()

            for i in self.profiles{
                profileNameList.append(i.name)
            }

            profileNameList.append("New Profile")
            
            profileSelectViewController.profilesList = profileNameList
            profileSelectViewController.thisIndex = self.profileIndex
            
        }
        
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    //can't solve the problem that why this method isn't called when use dismiss in next controller programmly
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
        
        
    }
    
    func popoverPresentationControllerShouldDismissPopover(popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }

    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.becomeFirstResponder()
        
        textField.selectedTextRange = textField.textRangeFromPosition(textField.beginningOfDocument, toPosition: textField.endOfDocument)
    }
    func textFieldDidEndEditing(textField: UITextField) {
        
        self.settings.name = self.textProfile.text!
    }
    
    func updateSettings(setting: Configuration) {
        self.settings = setting
        self.loadSetting(self.settings)
    }
    
    func whichItem(num: Int) {
        if num == 1{
            performSegueWithIdentifier("advancedSettingSegue", sender: self)
        }
        
    }
    
    func updateAdValue(setting: Configuration) {
        self.settings = setting
    }
    
    func profileSelected(num: Int) {
        if num == 0{
            
            self.profileIndex = num
            self.btnLabelSave.enabled = false
            self.loadSetting(self.profiles[self.profileIndex])
            
            
            self.editProfileMode(false)
        }else{
            
            //todo handle profile index for new file and new file delete
            self.profileIndex = num
            self.btnLabelSave.enabled = true
            
            
            if num == self.profiles.count{
                self.settings = Configuration()

                self.settings.name = "New Profile"
                self.loadSetting(settings)
                
            }else{
                self.settings = self.profiles[self.profileIndex]
                self.loadSetting(self.settings)
            }
           
            self.editProfileMode(true)
        }
    }
    
    func editProfileMode(isEditing: Bool){
        self.btnLabelSave.hidden = !isEditing
        self.btnLabelDelete.hidden = !isEditing
        self.textProfile.hidden = !isEditing
    }

}

