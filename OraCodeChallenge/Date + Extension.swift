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
}
