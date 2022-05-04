//
//  SpeechGrid.swift
//  SpeechGrid
//
//  Created by Andy Cho on 2/20/22.
//

/* Our speech grid. Populates tile page */

import Foundation
import Swift
import SwiftUI
import AVFoundation

struct SpeechGrid: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(fetchRequest: Tile.allTilesFetchRequest()) var allTiles: FetchedResults<Tile>
    
    let columns = [ GridItem(.adaptive(minimum: 100), spacing: 20) ]
    
    @State private var sentence = ""
    @State private var isEdit = false
    @EnvironmentObject var audioPlayer: AudioPlayer
    
    // Create an utterance.
    let utterance = AVSpeechUtterance(string: "")
    
    // Create a speech synthesizer.
    let synthesizer = AVSpeechSynthesizer()

    // Function to speak from text
    func speak(_ utterance: AVSpeechUtterance) {
        let utterance = AVSpeechUtterance(string: sentence)
            self.synthesizer.speak(utterance)
        }
    

    var body: some View {
        VStack {
            // This is our sentence box structure
            HStack {
                // Speak Button
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
                // Sentence Box
                TextEditor(text: $sentence)
                    .frame(height: 70)
                    .font(.custom("HelveticaNeue", size: 32))
                    .multilineTextAlignment(.center)
                // Clear Button
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
                
            // Tile Grid structure
            ScrollView {
                LazyVGrid(columns: columns, spacing: 3) {
                    // Loop through all tiles in database and populate grid
                    ForEach(allTiles, id: \.self) { word in
                        if (!word.frequency) {
                            // Each tiles in database is made into square button and upon click says the word
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
                            })
                            {
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
                                        .foregroundColor(Color(word.color ?? UIColor.blue))
                                        )
                            }
                            .padding(.vertical, 25)

                        }
                    }
                }
            }
            .border(Color.black, width: 3)
            
            // Word dock for more frequently used words
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(allTiles, id: \.self) { frequent in
                        if (frequent.frequency) {
                            Button(action: {
                                if (frequent.audio?.voiceRecording != nil) {
                                    sentence = sentence + " " + (frequent.word ?? "");
                                    // play word audios
                                    self.audioPlayer.createAudioPlayer(audioData: (frequent.audio?.voiceRecording)!)
                                    self.audioPlayer.startAudioPlayer()
                                }
                                else {
                                    sentence = sentence + " " + (frequent.word ?? "");
                                    self.synthesizer.speak(AVSpeechUtterance(string: frequent.word ?? ""))
                                }
                            }) {
                                VStack {
                                    getImageFromBinaryData(binaryData: frequent.photo?.tilePhoto, defaultFilename: "ImageUnavailable")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                    Text(frequent.word ?? "")
                                        .foregroundColor(Color.black)
                                    }
                                    .background(Rectangle()
                                        .frame(width: 100, height: 100)
                                        .opacity(0.3)
                                        .foregroundColor(Color(frequent.color ?? UIColor.blue)))
                                    .padding(.vertical, 25)
                                    .padding(.horizontal, 50)
                            }
                        }
                    }
                }
            }
            .padding(.vertical, 20)
        }
    }
}
