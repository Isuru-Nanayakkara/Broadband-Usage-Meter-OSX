//
//  MeterMenuController.swift
//  SLT Usage Meter
//
//  Created by Isuru Nanayakkara on 10/23/15.
//  Copyright © 2015 BitInvent. All rights reserved.
//

import Cocoa

class MeterMenuController: NSObject {
    
    @IBOutlet weak var menu: NSMenu!
    @IBOutlet weak var meterView: MeterView!
    @IBOutlet weak var startAtLoginMenuItem: NSMenuItem!
    
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSSquareStatusItemLength)
    let api = SLTAPI()
    let launchServicesHelper = LaunchServicesHelper()
    
    var meterMenuItem: NSMenuItem!
    var preferencesWindow: PreferencesWindow!
    
    override func awakeFromNib() {
        statusItem.image = NSImage(named: "statusIcon")
        statusItem.menu = menu
        
        meterMenuItem = menu.itemWithTitle("Meters")
        meterMenuItem.view = meterView
        
        preferencesWindow = PreferencesWindow()
        preferencesWindow.delegate = self
        
        startAtLoginMenuItem.state = launchServicesHelper.applicationIsInStartUpItems ? NSOnState : NSOffState
        
        login()
    }
    
    // HC2185334
    // Netass1st
    func login() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let userID = userDefaults.stringForKey("userID")
        let password = userDefaults.stringForKey("password")
        
        if let userID = userID, let password = password {
            if userID.isEmpty || password.isEmpty {
                preferencesWindow.showWindow(nil)
            } else {
                api.login(userID: userID, password: password, completion: { error in
                    if let error = error {
                        print("Error occurred when loggin in: \(error.localizedDescription)")
                        dispatch_async(dispatch_get_main_queue(), {
                            NSAlert(error: error).runModal()
                        })
                    } else {
                        print("Successfully logged in!")
                        self.updateUsage()
                    }
                })
            }
        } else {
            preferencesWindow.showWindow(nil)
        }
    }
    
    func updateUsage() {
        api.fetchUsage { usage, error in
            if let usage = usage {
                print(usage.description)
                print("Remaning data: \(usage.remainingTotalDataPercentage)%")
                print("Remaining Peak data: \(usage.remainingPeakDataPercentage)%")
                self.meterView.update(usage)
                
                self.registerForBackgroundUpdating()
            }
        }
    }
    
    func registerForBackgroundUpdating() {
        let timer = NSTimer(timeInterval: 300, target: self, selector: Selector("updateUsage"), userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
    }
    
    // MARK: - Actions
    @IBAction func quitItemClicked(sender: NSMenuItem) {
        NSApplication.sharedApplication().terminate(self)
    }
    
    @IBAction func preferencesItemClicked(sender: NSMenuItem) {
        preferencesWindow.showWindow(nil)
    }
    
    @IBAction func toggleStartAtLogin(sender: NSMenuItem) {
        launchServicesHelper.toggleLaunchAtStartup()
        startAtLoginMenuItem.state = launchServicesHelper.applicationIsInStartUpItems ? NSOnState : NSOffState
    }
    
}

// MARK: - PreferencesDelegate
extension MeterMenuController: PreferencesDelegate {
    func preferencesDidUpdate() {
        login()
    }
}
