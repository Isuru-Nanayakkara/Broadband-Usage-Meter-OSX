//
//  SLTAPI.swift
//  SLT Usage Meter
//
//  Created by Isuru Nanayakkara on 10/23/15.
//  Copyright © 2015 BitInvent. All rights reserved.
//

import Foundation

class SLTAPI {
    
    private let session = NSURLSession.sharedSession()
    private let baseURL = "https://www.internetvas.slt.lk/SLTVasPortal-war/"
    
    func login(userID userID: String, password: String, completion: (error: NSError?) -> ()) {
        let url = NSURL(string: baseURL + "login/j_security_check/j_security_check")!
        let params = ["j_username": userID, "j_password": password]
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.encodeParameters(params)
        session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    print("Something's fucky! - \(httpResponse)")
                    completion(error: error)
                } else {
                    let html = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
                    if html.containsString("Invalid Credentials") {
                        let errorDescription = "Invalid Credentails"
                        let recoverySuggestion = "Please enter the correct portal Username and Password"
                        let loginError = NSError(domain: "SLT-Usage-Error", code: 0, userInfo: [NSLocalizedDescriptionKey: errorDescription, NSLocalizedRecoverySuggestionErrorKey: recoverySuggestion])
                        completion(error: loginError)
                    } else {
                        completion(error: nil)
                    }
                }
            }
        }).resume()
    }
    
    func fetchUsage(completion: (usage: Usage, error: NSError?) -> ()) {
        let url = NSURL(string: baseURL + "application/GetProfile")!
        let request = NSURLRequest(URL: url)
        session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            let usage = Usage(jsonData: data!)
            completion(usage: usage, error: nil)
        }).resume()
    }
}

// see: http://stackoverflow.com/a/31031859/1077789
extension NSMutableURLRequest {
    
    /// Percent escape
    ///
    /// Percent escape in conformance with W3C HTML spec:
    ///
    /// See http://www.w3.org/TR/html5/forms.html#application/x-www-form-urlencoded-encoding-algorithm
    ///
    /// - parameter string:   The string to be percent escaped.
    /// - returns:            Returns percent-escaped string.
    
    private func percentEscapeString(string: String) -> String {
        let characterSet = NSCharacterSet.alphanumericCharacterSet().mutableCopy() as! NSMutableCharacterSet
        characterSet.addCharactersInString("-._* ")
        
        return string
            .stringByAddingPercentEncodingWithAllowedCharacters(characterSet)!
            .stringByReplacingOccurrencesOfString(" ", withString: "+", options: [], range: nil)
    }
    
    /// Encode the parameters for `application/x-www-form-urlencoded` request
    ///
    /// - parameter parameters:   A dictionary of string values to be encoded in POST request
    
    func encodeParameters(parameters: [String : String]) {
        HTTPMethod = "POST"
        
        let parameterArray = parameters.map { (key, value) -> String in
            return "\(key)=\(self.percentEscapeString(value))"
        }
        
        HTTPBody = parameterArray.joinWithSeparator("&").dataUsingEncoding(NSUTF8StringEncoding)
    }
}