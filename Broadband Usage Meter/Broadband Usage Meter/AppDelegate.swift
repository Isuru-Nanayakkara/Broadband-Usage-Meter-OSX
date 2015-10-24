//
//  AppDelegate.swift
//  Broadband Usage Meter
//
//  Created by Isuru Nanayakkara on 10/24/15.
//  Copyright © 2015 BitInvent. All rights reserved.
//

import Cocoa
import LetsMove

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        
        // Move teh app to the application folder to avoid users from running the app from disk
//        PFMoveToApplicationsFolderIfNecessary()
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
}