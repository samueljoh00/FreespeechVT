//
//  SpeechGrid.swift
//  SpeechGrid
//
//  Created by Andy Cho on 2/20/22.
//

import Foundation
import Swift
import SwiftUI
import AVFoundation

struct SpeechGrid: View {
    
    @EnvironmentObject var userData: UserData
    
    let columns = [ GridItem(.adaptive(minimum: 100), spacing: 20) ]
    
    @State private var sentence = ""
    
    // Create an utterance.
    let utterance = AVSpeechUtterance(string: "")
    
    // Create a speech synthesizer.
    let synthesizer = AVSpeechSynthesizer()

    func speak(_ utterance: AVSpeechUtterance) {
        let utterance = AVSpeechUtterance(string: sentence)
            self.synthesizer.speak(utterance)
        }

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    speak(utterance)
                }) {
                    Text("Speak")
                        .foregroundColor(Color.black)
                        .background(Rectangle()
                                        .frame(width: 50, height: 50)
                                        .opacity(0.3)
                                        .foregroundColor(Color.gray))
                }
                .padding()
                TextEditor(text: $sentence)
                    .frame(height: 70)
    //                .overlay(
    //                    RoundedRectangle(cornerRadius: 16)
    //                        .stroke(Color.gray, lineWidth: 4)
    //                )
                    .font(.custom("HelveticaNeue", size: 32))
                    .multilineTextAlignment(.center)
//                    .border(Color.black, width: 3)
                Button(action: {
                    sentence = ""
                }) {
                    Text("Clear")
                        .foregroundColor(Color.black)
                        .background(Rectangle()
                                        .frame(width: 50, height: 50)
                                        .opacity(0.3)
                                        .foregroundColor(Color.gray))
                }
                .padding()
            }
                
            ScrollView {
                LazyVGrid(columns: columns, spacing: 3) {
                    ForEach(userData.wordsList, id: \.self) { word in
                        Button(action: {
                            sentence = sentence + " " + word.name
                        }) {
                            Text(word.name)
                                .foregroundColor(Color.black)
                                .background(Rectangle()
                                                .frame(width: 100, height: 100)
                                                .opacity(0.3)
                                                .foregroundColor(Color.blue))
                        }
                        .padding(.vertical, 50)
                    }
                }
            }
            .border(Color.black, width: 3)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(userData.wordsList, id: \.self) { word in
                        Button(action: {
                            sentence = sentence + " " + word.name
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
//            .overlay(
//                RoundedRectangle(cornerRadius: 16)
//                    .stroke(Color.gray, lineWidth: 4)
//            )
        }
    }
}
