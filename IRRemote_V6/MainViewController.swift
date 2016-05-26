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
        //two parts, first time open app, load default setting; loading from loal files,
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
        
        btnLabelProfile.setTitle((config.name), forState: .Normal)
        textProfile.text = config.name
        
        
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
            print("this is name in parent view")
            print(self.settings.name)
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
            print("this is original list size:")
            print(profileNameList.count)
            for i in self.profiles{
                profileNameList.append(i.name)
            }
            print(profileNameList.count)
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
    
    func textFieldDidEndEditing(textField: UITextField) {
        print("doen with deiting a")
        
        self.settings.name = self.textProfile.text!
    }
    
    func updateSettings(setting: Configuration) {
        self.settings = setting
        print("parent shows up")
        //dont' need this method to load all the view again
        //self.viewDidLoad()
        self.loadSetting(self.settings)
    }
    
    func whichItem(num: Int) {
        if num == 1{
            performSegueWithIdentifier("advancedSettingSegue", sender: self)
        }
        
    }
    
    func updateAdValue(setting: Configuration) {
        self.settings = setting
        print("parent shows up")
    }
    
    func profileSelected(num: Int) {
        print(num)
        if num == 0{
            
            self.profileIndex = num
            self.btnLabelSave.enabled = false
            self.loadSetting(self.profiles[self.profileIndex])
            print("select default file")
            
            self.editProfileMode(false)
        }else{
            
            //todo handle profile index for new file and new file delete
            self.profileIndex = num
            self.btnLabelSave.enabled = true
            
            
            if num == self.profiles.count{
                self.settings = Configuration()

                self.settings.name = "New Profile"
                self.loadSetting(settings)
                
                print("open a new file ")
                
            }else{
                self.settings = self.profiles[self.profileIndex]
                self.loadSetting(self.settings)
                print("select this index file", num)
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

