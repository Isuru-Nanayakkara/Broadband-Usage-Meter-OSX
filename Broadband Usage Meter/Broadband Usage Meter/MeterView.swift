//
//  MeterView.swift
//  SLT Usage Meter
//
//  Created by Isuru Nanayakkara on 10/23/15.
//  Copyright © 2015 BitInvent. All rights reserved.
//

import Cocoa

class MeterView: NSView {
    
    @IBOutlet weak var peakLevelIndicator: NSLevelIndicator!
    @IBOutlet weak var totalLevelIndicator: NSLevelIndicator!
    @IBOutlet weak var peakPercentageLabel: NSTextField!
    @IBOutlet weak var totalPercentageLabel: NSTextField!
    
    func update(usage: Usage) {
        dispatch_async(dispatch_get_main_queue()) {
            self.peakLevelIndicator.doubleValue = usage.remainingPeakData
            self.peakLevelIndicator.toolTip = "\(usage.remainingPeakData) GB Left"
            self.peakPercentageLabel.stringValue = "\(Int(usage.remainingPeakDataPercentage))%"
            
            self.totalLevelIndicator.doubleValue = usage.remainingTotalData
            self.totalLevelIndicator.toolTip = "\(usage.remainingTotalData) GB Left"
            self.totalPercentageLabel.stringValue = "\(Int(usage.remainingTotalDataPercentage))%"
        }
    }
}
