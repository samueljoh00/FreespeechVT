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
    @State private var isEdit = false
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
                        if (!word.frequency) {
                            Button(action: {
//                                let thisWord = word
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
                            .simultaneousGesture(LongPressGesture(minimumDuration: 1).onEnded({ _ in
                                self.isEdit = true
                            }))
                            .sheet(isPresented: self.$isEdit) {
                                EditTile(currTile: word)
                            }
                        }
                    }
                }
            }
            .border(Color.black, width: 3)
//            .tabViewStyle(.page)
            
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
                            .simultaneousGesture(LongPressGesture(minimumDuration: 1).onEnded({ _ in
                                self.isEdit = true
                            }))
                            .sheet(isPresented: self.$isEdit) {
                                EditTile(currTile: frequent)
                            }
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
    
    /*
     ------------------------------
     MARK: - Delete Selected Recipe
     ------------------------------
     */
    func delete(at offsets: IndexSet) {
        
        let tileToDelete = allTiles[offsets.first!]
        
        // ❎ CoreData Delete operation
        managedObjectContext.delete(tileToDelete)
        
        // ❎ CoreData Save operation
        do {
            try managedObjectContext.save()
        } catch {
            print("Unable to delete selected tile!")
        }
    }
}
