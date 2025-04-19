//
//  View+Ext.swift
//  Campfire
//
//  Created by Justin Wong on 4/19/25.
//

import SwiftUI

extension TextEditor {
    @ViewBuilder func hideBackground() -> some View { if #available(iOS 16, *) { self.scrollContentBackground(.hidden) } else { self }
    }
}
