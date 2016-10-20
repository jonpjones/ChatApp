//
//  NSDate + Extension.swift
//  OraCodeChallenge
//
//  Created by Jonathan Jones on 10/20/16.
//  Copyright © 2016 Jon Jones. All rights reserved.
//

import Foundation

extension Date {
    func string() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        return dateFormatter.string(from: self)
    }
    
    func timeSinceDate() -> String {
        let cal = Calendar.current
        let components = cal.dateComponents([.year, .weekOfYear,.month, .day, .hour, .minute], from: self, to: Date())
        
        if components.year! >= 2 {
            return "\(components.year!) years ago"
        } else if components.year! == 1 {
            return "1 year ago"
        }
        
        if components.month! >= 2 {
            return "\(components.month!) months ago"
        } else if components.month! == 1 {
            return "1 month ago"
        }
        
        if components.weekOfYear! >= 2 {
            return "\(components.weekOfYear!) weeks ago"
        } else if components.weekOfYear! == 1 {
            return "1 week ago"
        }
        
        if components.day! >= 2 {
            return "\(components.day!) days ago"
        } else if components.day == 1 {
            return "yesterday"
        }
        
        if components.hour! >= 2 {
            return "\(components.hour!) hours ago"
        } else if components.hour! == 1 {
            return "1 hour ago"
        }
        
        if components.minute! >= 2 {
            return "\(components.minute!) minutes ago"
        } else if components.minute! == 1 {
            return "1 minute ago"
        }
        
        return "just now"
    }
}
