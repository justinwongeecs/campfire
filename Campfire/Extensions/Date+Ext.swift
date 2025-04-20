//
//  Date+Ext.swift
//  Campfire
//
//  Created by Justin Wong on 4/19/25.
//

import Foundation

extension Date {
    func getISOString() -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        formatter.timeZone = TimeZone(secondsFromGMT: 0)

        return formatter.string(from: self)
    }
}
