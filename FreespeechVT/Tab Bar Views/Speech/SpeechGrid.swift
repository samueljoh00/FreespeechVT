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
    
    // ❎ CoreData managedObjectContext reference
    @Environment(\.managedObjectContext) var managedObjectContext
    
    // ❎ CoreData FetchRequest returning all music album entities in the database
    @FetchRequest(fetchRequest: Tile.allTilesFetchRequest()) var allTiles: FetchedResults<Tile>
    
    //@EnvironmentObject var userData: UserData
    
    let columns = [ GridItem(.adaptive(minimum: 100), spacing: 20) ]
    
    @State private var sentence = ""
    @EnvironmentObject var audioPlayer: AudioPlayer
    
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
                    ForEach(allTiles, id: \.self) { word in
                        Button(action: {
                            if (word.audio?.voiceRecording != nil) {
                                sentence = sentence + " " + (word.word ?? "");
                                // play word audios
                                self.audioPlayer.createAudioPlayer(audioData: (word.audio?.voiceRecording)!)
                                self.audioPlayer.startAudioPlayer()
                            }
                            else {
                                sentence = sentence + " " + (word.word ?? "");
                                self.synthesizer.speak(AVSpeechUtterance(string: word.word ?? ""))
                            }
                        }) {
                            VStack {
                                getImageFromBinaryData(binaryData: word.photo?.tilePhoto, defaultFilename: "ImageUnavailable")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                Text(word.word ?? "")
                                    .foregroundColor(Color.black)
                                }
                                .background(Rectangle()
                                    .frame(width: 100, height: 100)
                                    .opacity(0.3)
                                    .foregroundColor(Color.blue))
                        }
                        .padding(.vertical, 25)
                    }
                }
            }
            .border(Color.black, width: 3)
//            .tabViewStyle(.page)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(allTiles, id: \.self) { word in
                        Button(action: {
                            if (word.audio?.voiceRecording != nil) {
                                sentence = sentence + " " + (word.word ?? "");
                                // play word audios
                                self.audioPlayer.createAudioPlayer(audioData: (word.audio?.voiceRecording)!)
                                self.audioPlayer.startAudioPlayer()
                            }
                            else {
                                sentence = sentence + " " + (word.word ?? "");
                                self.synthesizer.speak(AVSpeechUtterance(string: word.word ?? ""))
                            }
                        }) {
                            VStack {
                                getImageFromBinaryData(binaryData: word.photo?.tilePhoto, defaultFilename: "ImageUnavailable")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                Text(word.word ?? "")
                                    .foregroundColor(Color.black)
                                }
                                .background(Rectangle()
                                    .frame(width: 100, height: 100)
                                    .opacity(0.3)
                                    .foregroundColor(Color.red))
                                .padding(.vertical, 25)
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
