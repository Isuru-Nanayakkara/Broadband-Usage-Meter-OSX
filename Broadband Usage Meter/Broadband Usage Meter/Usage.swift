//
//  Usage.swift
//  SLT Usage Meter
//
//  Created by Isuru Nanayakkara on 10/23/15.
//  Copyright © 2015 BitInvent. All rights reserved.
//

import Foundation

struct Usage: CustomStringConvertible {
    var totalData: Double
    var remainingTotalData: Double
    var totalPeakData: Double
    var remainingPeakData: Double
    
    private let gigabyteInBytes: Double = 1073741824
    
    init?(jsonData: NSData) {
        var jsonDict = [String: AnyObject]()
        
        do {
            jsonDict = try NSJSONSerialization.JSONObjectWithData(jsonData, options: []) as! [String: AnyObject]
        } catch {
            print("Error occurred parsing data: \(error)")
            return nil
        }
        print(jsonDict)
        
        let multiplier = pow(10.0, 1)
        
        totalData = (jsonDict["totalfup"] as! NSString).doubleValue
        remainingTotalData = round((jsonDict["totalrem"] as! NSString).doubleValue / gigabyteInBytes * multiplier) / multiplier
        totalPeakData = (jsonDict["peakfup"] as! NSString).doubleValue
        remainingPeakData = round((jsonDict["peakrem"] as! NSString).doubleValue / gigabyteInBytes * multiplier) / multiplier
    }
    
    var remainingTotalDataPercentage: Double {
        let totalRemaining = 100 - totalData
        return round(totalRemaining)
    }
    
    var remainingPeakDataPercentage: Double {
        let peakRemaining = 100 - totalPeakData
        return round(peakRemaining)
    }
    
    var description: String {
        return "Total Data: \(totalData)\nRemaining Total Data: \(remainingTotalData)\nTotal Peak Data: \(totalPeakData)\nRemaining Peak Data: \(remainingPeakData)"
    }
}