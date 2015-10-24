//
//  NSAttributedString+Extensions.swift
//  SLT Usage Meter
//
//  Created by Isuru Nanayakkara on 10/23/15.
//  Copyright © 2015 BitInvent. All rights reserved.
//

import AppKit

extension NSAttributedString {
    class func hyperlinkFromString(aString: String, withURL url: NSURL) -> NSAttributedString {
        let attrString = NSMutableAttributedString(string: aString)
        let range = NSMakeRange(0, attrString.length)
        
        attrString.beginEditing()
        attrString.addAttribute(NSLinkAttributeName, value: url.absoluteString, range: range)
        attrString.addAttribute(NSForegroundColorAttributeName, value: NSColor.blueColor(), range: range)
        attrString.addAttribute(NSUnderlineStyleAttributeName, value: NSNumber(integer: NSUnderlineStyle.StyleSingle.rawValue), range: range)
        attrString.endEditing()
        
        return attrString
    }
}