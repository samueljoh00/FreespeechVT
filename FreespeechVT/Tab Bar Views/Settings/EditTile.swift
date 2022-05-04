//
//  EditTile.swift
//  EditTile
//
//  Created by Andy Cho on 3/9/22.
//  Copyright © 2022 FreespeechVT. All rights reserved.
//

import Foundation
import SwiftUI
import AVFoundation

/* Edit tile page to edit a chosen tile within a list */

struct EditTile: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: Tile.allTilesFetchRequest()) var allTiles: FetchedResults<Tile>
    
    // Tile that is passed to edit
    let currTile: Tile
    
    // Private variables to hold our edit tile inputs
    @State private var showTileEditedAlert = false
    @State private var showInputDataMissingAlert = false
    @State private var recordingVoice = false
    var photoTakeOrPickChoices = ["Camera", "Photo Library"]
    @State private var showImagePicker = false
    @State private var photoImageData: Data? = nil
    @State private var photoTakeOrPickIndex = 1
    
    @State private var frequentWord = false
    
    @State private var word = ""
    @State private var colorIndex = 2
    let colorChoices = ["Blue", "Green", "Yellow"]
    let colorStorage = [UIColor.blue, UIColor.green, UIColor.yellow]
    
    @State private var showTileDeleted = false
    
    var body: some View {
            Form {
                Section(header: Text("Word")) {
                    HStack {
                        TextField("Enter Word", text: $word)
                            .onAppear {
                                self.word = currTile.word ?? ""
                            }
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button(action: {
                            self.word = ""
                        }) {
                            Image(systemName: "clear")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                    }
                }
                Section(header: Text("")) {
                    VStack {
                        Picker("Take or Pick Photo", selection: $photoTakeOrPickIndex) {
                            ForEach(0 ..< photoTakeOrPickChoices.count, id: \.self) {
                                Text(photoTakeOrPickChoices[$0])
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()
                        
                        Button(action: {
                            showImagePicker = true
                        }) {
                            Text("Get Photo")
                                .padding()
                        }
                    }
                }
                Section(header: Text("Take Notes by Recording Your Voice")) {
                    Button(action: {
                        self.voiceRecordingMicrophoneTapped()
                    }) {
                        voiceRecordingMicrophoneLabel
                    }
                }
                Section(header: Text("Tile Photo")) {
                    if (currTile.photo?.tilePhoto != nil) {
                        getImageFromBinaryData(binaryData: currTile.photo?.tilePhoto, defaultFilename: "ImageUnavailable")                        .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100.0, height: 100.0)
                    }
                    else {
                        Image("ImageUnavailable")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100.0, height: 100.0)
                    }
                }
                Section(header: Text("Tile Color")) {
                    Picker("", selection: $colorIndex) {
                        ForEach(0 ..< colorChoices.count, id: \.self) {
                            Text(colorChoices[$0])
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(minWidth: 300, maxWidth: 500, alignment: .center)
                    .onAppear {
                        self.colorIndex = colorStorage.firstIndex(where: {$0 == currTile.color ?? UIColor.blue})!
                        self.currTile.color = colorStorage[colorIndex]
                    }
                }
                Section(header: Text("Word Dock")) {
                    Toggle(isOn: $frequentWord) {
                        Text("Place tile into the word dock")
                    }
                }
                .alert(isPresented: $showTileDeleted, content: { tileDeleted })
            }
            .navigationBarTitle(Text("Edit Tile"), displayMode: .inline)
            .navigationBarItems(
                leading:
                    Button(action: {
                        showTileDeleted = true
                        managedObjectContext.delete(currTile)
                    }) {
                        Text("Delete")
                    },
                trailing:
                    Button(action: {
                        if inputDataValidated() {
                            saveTile()
                            showTileEditedAlert = true
                        } else {
                            showInputDataMissingAlert = true
                        }
                    }) {
                        Text("Save")
                    })
            .customNavigationViewStyle()
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .autocapitalization(.words)
            .disableAutocorrection(true)
            .font(.system(size: 14))
            .alert(isPresented: $showTileDeleted, content: { tileDeleted })
            .alert(isPresented: $showInputDataMissingAlert, content: { inputDataMissingAlert })
            .alert(isPresented: $showTileEditedAlert, content: { tileEditedAlert })
            .sheet(isPresented: $showImagePicker) {
                PhotoCaptureView(showImagePicker: $showImagePicker,
                                 photoImageData: $photoImageData,
                                 cameraOrLibrary: photoTakeOrPickChoices[photoTakeOrPickIndex])
            }
    }
    
    // Alerts when input data is missing
    var inputDataMissingAlert: Alert {
        Alert(title: Text("Missing Input Data!"),
              message: Text("Missing word input"),
              dismissButton: .default(Text("OK")) )
    }
    
    // Alerts when tile has been edited
    var tileEditedAlert: Alert {
        Alert(title: Text("Tile Edited!"),
              message: Text("Updated tile is added to your tile grid!"),
              dismissButton: .default(Text("OK")) {
                  presentationMode.wrappedValue.dismiss()
            })
    }
    
    // Validates whether our tile has valid inputs or not
    func inputDataValidated() -> Bool {
        if word.isEmpty {
            return false
        }
        return true
    }
    
    // Saves the tile
    func saveTile() {
        
        let newTile = currTile
        
        newTile.word = word
        newTile.color = colorStorage[colorIndex]
        newTile.frequency = frequentWord
        
        let newPhoto = Photo(context: managedObjectContext)
        
        if let imageData = photoImageData {
            newPhoto.tilePhoto = imageData
        } else {
            let photoUIImage = UIImage(named: "ImageUnavailable")
            
            let photoData = photoUIImage?.jpegData(compressionQuality: 1.0)
            
            newPhoto.tilePhoto = photoData!
        }
        let aAudio = Audio(context: self.managedObjectContext)
        
        do {
            aAudio.voiceRecording = try Data(contentsOf: temporaryAudioFileUrl, options: NSData.ReadingOptions.mappedIfSafe)
            
        } catch {
            aAudio.voiceRecording = nil
        }
        
        // Link tile, photo, and audio var together
        newTile.photo = newPhoto    // An album can have only one photo
        newPhoto.tile = newTile    // A photo can belong to only one album
        newTile.audio = aAudio
        aAudio.relevantTile = newTile
        
        do {
            try managedObjectContext.save()
        } catch {
            return
        }
    }
    
    // Displays the recording label in section
    var voiceRecordingMicrophoneLabel: some View {
        VStack {
            Image(systemName: recordingVoice ? "mic.fill" : "mic.slash.fill")
                .imageScale(.large)
                .font(Font.title.weight(.medium))
                .foregroundColor(.blue)
                .padding()
            Text(recordingVoice ? "Recording your voice... Tap to Stop!" : "Start Recording!")
                .multilineTextAlignment(.center)
        }
    }
    
    // Determines whether the recording label has been tapped or not
    func voiceRecordingMicrophoneTapped() {
        if audioRecorder == nil {
            self.recordingVoice = true
            startRecording()
        } else {
            self.recordingVoice = false
            finishRecording()
        }
    }
    
    // Finishes our recording
    func finishRecording() {
        audioRecorder.stop()
        audioRecorder = nil
        self.recordingVoice = false
    }
    
    // Handles when recording is started
    func startRecording() {
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            try FileManager.default.removeItem(at: temporaryAudioFileUrl)
        } catch {

        }
        
        do {
            audioRecorder = try AVAudioRecorder(url: temporaryAudioFileUrl, settings: settings)
            audioRecorder.record()
        } catch {
            finishRecording()
        }
    }
    
    // Alerts when tile has been deleted
    var tileDeleted: Alert {
        Alert(title: Text("Tile Deleted!"),
              message: Text("The tile was deleted from the grid."),
              dismissButton: .default(Text("OK")) {
                  presentationMode.wrappedValue.dismiss()
            })
    }
    
}
