//
//  CFEmptyView.swift
//  Campfire
//
//  Created by Justin Wong on 4/20/25.
//

import SwiftUI

struct CFEmptyView: View {
    var message: String
    
    var body: some View {
        Text(message)
            .font(CFFont.italic(20))
            .foregroundStyle(.gray)
    }
}

#Preview {
    CFEmptyView(message: "No Catchups Available For Today")
}
