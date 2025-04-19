//
//  CFFont.swift
//  Campfire
//
//  Created by Justin Wong on 4/19/25.
//

import SwiftUI

struct CFFont {
    static let regular = {
        (size: CGFloat) -> Font in
        return Font.custom("Arvo", size: size)
    }
    
    static let italic = {
        (size: CGFloat) -> Font in
        return Font.custom("Arvo-Italic", size: size)
    }
    
    static let bold = {
        (size: CGFloat) -> Font in
        return Font.custom("Arvo-Bold", size: size)
    }
    
    static let boldItalic = {
        (size: CGFloat) -> Font in
        return Font.custom("Arvo-BoldItalic", size: size)
    }
}
