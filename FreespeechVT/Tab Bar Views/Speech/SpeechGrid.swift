//
//  SpeechGrid.swift
//  SpeechGrid
//
//  Created by Andy Cho on 2/20/22.
//

import Foundation
import Swift
import SwiftUI

struct SpeechGrid: View {
    
    @EnvironmentObject var userData: UserData
    
    let columns = [ GridItem(.adaptive(minimum: 100), spacing: 20) ]
    
    @State private var sentence = ""

    var body: some View {
        VStack {
            // add sentence preview box
            TextEditor(text: $sentence)
                .frame(height: 70)
            ScrollView {
                LazyVGrid(columns: columns, spacing: 3) {
                    ForEach(userData.wordsList, id: \.self) { word in
                        Text(word.name)
                            .background(Rectangle()
                                            .frame(width: 100, height: 100)
                                            .opacity(0.3)
                                            .foregroundColor(Color.blue))
                    }
                    .padding(.vertical, 50)
                }
            }
        }
    }
}
