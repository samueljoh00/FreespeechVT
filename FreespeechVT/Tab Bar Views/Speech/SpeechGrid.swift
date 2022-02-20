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
    
    let columns = [ GridItem(.adaptive(minimum: 100), spacing: 3) ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 3) {
                ForEach(/* Data of each tile */) {
                    Text(/* Text of the current word */)
                }
            }
        }
    }
}
