//
//  PreferencesWindow.swift
//  SLT Usage Meter
//
//  Created by Isuru Nanayakkara on 10/23/15.
//  Copyright © 2015 BitInvent. All rights reserved.
//

import Cocoa

protocol PreferencesDelegate {
    func preferencesDidUpdate()
}

class PreferencesWindow: NSWindowController, NSWindowDelegate {

    @IBOutlet weak var userIDTextField: NSTextField!
    @IBOutlet weak var passwordTextField: NSSecureTextField!
    
    var delegate: PreferencesDelegate?
    
    override var windowNibName: String {
        return "PreferencesWindow"
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        window?.center()
        window?.makeKeyAndOrderFront(nil)
        NSApp.activateIgnoringOtherApps(true)
        
        // TODO: Refector NSUserDefaults code duplication
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let userID = userDefaults.stringForKey("userID")
        let password = userDefaults.stringForKey("password")
        
        if let userID = userID, let password = password {
            userIDTextField.stringValue = userID
            passwordTextField.stringValue = password
        }
        
        // TODO: Add this in the next version. Current placement of the label is ugly
//        registerLabel.allowsEditingTextAttributes = true
//        registerLabel.selectable = true
//        
//        let url = NSURL(string: "https://www.internetvas.slt.lk/SLTVasPortal-war/register/register.jsp")!
//        let str = NSMutableAttributedString(string: "If you don't have a portal account, create one ")
//        str.appendAttributedString(NSAttributedString.hyperlinkFromString("here", withURL: url))
//        registerLabel.attributedStringValue = str
//        registerLabel.alignment = .Center
    }
    
    @IBAction func loginButtonClicked(sender: NSButton) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setValue(userIDTextField.stringValue, forKey: "userID")
        userDefaults.setValue(passwordTextField.stringValue, forKey: "password")
        
        delegate?.preferencesDidUpdate()
        close()
    }
    
}
