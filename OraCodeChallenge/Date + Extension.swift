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
    
    func timeSinceDate(date: Date) -> String {
        let cal = Calendar.current
        let components = cal.dateComponents([.year, .weekOfYear,.month, .day, .hour, .minute], from: date, to: Date())
        
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
//    func timeUntil(endDate: NSDate) -> String {
//        let cal = NSCalendar.currentCalendar()
//        let minute = NSCalendarUnit.Minute
//        
//        let minutes = cal.components(minute, fromDate: self, toDate: endDate, options: NSCalendarOptions.MatchNextTimePreservingSmallerUnits)
//        
//        let leftOverHours = minutes.valueForComponent(minute) % 1440
//        
//        let daysLeft = minutes.valueForComponent(minute) / 1440
//        let hoursLeft = leftOverHours / 60
//        let minutesLeft = leftOverHours % 60
//        var daysString: String!
//        var hoursString: String!
//        var minutesString: String!
//        
//        if daysLeft == 1 {
//            daysString = "1 day,"
//        } else if daysLeft == 0 {
//            daysString = ""
//        } else {
//            daysString = "\(daysLeft) days,"
//        }
//        
//        if minutesLeft == 1 {
//            minutesString = "and 1 minute,"
//        } else if minutesLeft == 0 {
//            minutesString = ""
//        } else {
//            minutesString = "and \(minutesLeft) minutes"
//        }
//        
//        if hoursLeft == 1 {
//            hoursString = "1 hour,"
//        } else if hoursLeft == 0 {
//            hoursString = ""
//        } else {
//            hoursString = "\(hoursLeft) hours,"
//        }
//        
//        return ("\(daysString) \(hoursString) \(minutesString)")
//    }

}
