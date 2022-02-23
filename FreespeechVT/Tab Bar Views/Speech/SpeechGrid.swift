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
    
    let columns = [ GridItem(.adaptive(minimum: 100), spacing: 10) ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 3) {
                ForEach(userData.wordsList, id: \.self) { word in
                    Text(word.name)
                        .background(Rectangle()
                                        .frame(width: 100, height: 100)
                                        .opacity(100))
                }
            }
        }
    }
}
