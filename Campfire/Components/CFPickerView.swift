//
//  CFPickerView.swift
//  Campfire
//
//  Created by Justin Wong on 4/19/25.
//

import SwiftUI

struct CFPickerView: View {
    var titles: [String]
    @Binding var selection: Int
    
    var body: some View {
        HStack {
            ForEach(Array(titles.enumerated()), id: \.offset) { idx, title in
                Button(action: {
                    withAnimation {
                        selection = idx
                    }
                }) {
                    Text(title)
                        .foregroundStyle(.black)
                        .padding(10)
                        .background(idx == selection ? .red.opacity(0.4) : .clear)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
            }
        }
        .padding(10)
        .background(.orange.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 40))
        .font(CFFont.bold(16))
        .frame(width: 250)
    }
}

#Preview {
    @Previewable @State var selection: Int = 0
    
    ZStack {
        Color.orange.opacity(0.2)
            .ignoresSafeArea()
        CFPickerView(titles: ["CatchUp", "Contacts"], selection: $selection)
            .padding()
    }
}
