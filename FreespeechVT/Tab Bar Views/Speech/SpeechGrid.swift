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
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray, lineWidth: 4)
                )
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
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(userData.wordsList, id: \.self) { word in
                        Button(action: {
                            //
                        }) {
                            VStack {
                                Text(word.name)
                                    .foregroundColor(Color.black)
                                    .background(Rectangle()
                                                    .frame(width: 100, height: 100)
                                                    .opacity(0.3)
                                                    .foregroundColor(Color.red))
                            }
                            .padding(.horizontal, 50)
    //                        .foregroundColor(userData.wordsList[m] == self.searchItem ? .red : .black)
                        }
                    }
                } // end of overall hstack
            } // end of scrollview
            .padding(.vertical, 20)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.gray, lineWidth: 4)
            )
        }
    }
}
