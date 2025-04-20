//
//  String+Ext.swift
//  Campfire
//
//  Created by Justin Wong on 4/19/25.
//

import Foundation

extension String {
    private static var digits = UnicodeScalar("0")..."9"
    
    var digits: String {
        return String(unicodeScalars.filter(String.digits.contains))
    }
    
    func toDateFromISOString() -> Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.date(from: self)
    }
}
