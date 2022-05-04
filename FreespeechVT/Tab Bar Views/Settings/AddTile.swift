//
//  AddTile.swift
//  AddTile
//
//  Created by Andy Cho on 3/9/22.
//  Copyright © 2022 FreespeechVT. All rights reserved.
//

import Foundation
import SwiftUI
import AVFoundation

let temporaryAudioFileUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("temp.m4a")

struct AddTile: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    // Private variables to hold our add tile inputs
    @State private var showTileAddedAlert = false
    @State private var showInputDataMissingAlert = false
    
    @State private var recordingVoice = false
    
    var photoTakeOrPickChoices = ["Camera", "Photo Library"]
    @State private var showImagePicker = false
    @State private var photoImageData: Data? = nil
    @State private var photoTakeOrPickIndex = 1
    
    @State private var word = ""
    @State private var frequentWord = false
    
    @State private var colorIndex = 2
    let colorChoices = ["Blue", "Green", "Yellow"]
    let colorStorage = [UIColor.blue, UIColor.green, UIColor.yellow]
    
    // Section form with textfields and tile data inputs
    var body: some View {
        Form {
            Section(header: Text("Word")) {
                HStack {
                    TextField("Enter Word", text: $word)
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
                }   // End of VStack
            }
            Section(header: Text("Tile Recording")) {
                Button(action: {
                    self.voiceRecordingMicrophoneTapped()
                }) {
                    voiceRecordingMicrophoneLabel
                }
            }
            Section(header: Text("Tile Photo")) {
                photoImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100.0, height: 100.0)
            }
            Section(header: Text("Tile Color")) {
                Picker("", selection: $colorIndex) {
                    ForEach(0 ..< colorChoices.count, id: \.self) {
                        Text(colorChoices[$0])
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(minWidth: 300, maxWidth: 500, alignment: .center)
            }
            Section(header: Text("Word Dock")) {
                Toggle(isOn: $frequentWord) {
                    Text("Place tile into the word dock")
                }
            }
        }
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .autocapitalization(.words)
        .disableAutocorrection(true)
        .font(.system(size: 14))
        .alert(isPresented: $showInputDataMissingAlert, content: { inputDataMissingAlert })
        .alert(isPresented: $showTileAddedAlert, content: { tileAddedAlert })
        .navigationBarTitle(Text("Add Tile"), displayMode: .inline)
        .navigationBarItems(trailing:
            Button(action: {
                if inputDataValidated() {
                    saveTile()
                    showTileAddedAlert = true
                } else {
                    showInputDataMissingAlert = true
                }
            }) {
                Text("Save")
            })
        
        .sheet(isPresented: $showImagePicker) {
            PhotoCaptureView(showImagePicker: $showImagePicker,
                             photoImageData: $photoImageData,
                             cameraOrLibrary: photoTakeOrPickChoices[photoTakeOrPickIndex])
        }
    }
    
    // Our photo from pick or take
    var photoImage: Image {
        if let imageData = photoImageData {
            let imageView = getImageFromBinaryData(binaryData: imageData, defaultFilename: "ImageUnavailable")
            return imageView
        } else {
            return Image("ImageUnavailable")
        }
    }
    
    // Sends alert that input is missing some data
    var inputDataMissingAlert: Alert {
        Alert(title: Text("Missing Input Data!"),
              message: Text("Missing word input"),
              dismissButton: .default(Text("OK")) )
    }
    
    // Sends an alert when tile is added
    var tileAddedAlert: Alert {
        Alert(title: Text("Tile Added!"),
              message: Text("New tile is added to your tile grid!"),
              dismissButton: .default(Text("OK")) {
                  presentationMode.wrappedValue.dismiss()
            })
    }
    
    // Checks if the tile is valid to save
    func inputDataValidated() -> Bool {
        if word.isEmpty {
            return false
        }
        
        return true
    }
    
    // Saves the tile to data
    func saveTile() {

        // new tile variable
        let newTile = Tile(context: managedObjectContext)
        
        // Store each field into new tile
        newTile.word = word
        newTile.color = colorStorage[colorIndex]
        newTile.frequency = frequentWord
        
        // Create new photo
        let newPhoto = Photo(context: managedObjectContext)
        
        if let imageData = photoImageData {
            newPhoto.tilePhoto = imageData
        } else {
            // tile default image
            let photoUIImage = UIImage(named: "ImageUnavailable")
            let photoData = photoUIImage?.jpegData(compressionQuality: 1.0)
            newPhoto.tilePhoto = photoData!
        }
        let aAudio = Audio(context: self.managedObjectContext)

        do {
            // Audio file
            aAudio.voiceRecording = try Data(contentsOf: temporaryAudioFileUrl, options: NSData.ReadingOptions.mappedIfSafe)
            
        } catch {
            aAudio.voiceRecording = nil
        }
        
        // Link tile, photo, and audio var together
        newTile.photo = newPhoto
        newPhoto.tile = newTile
        newTile.audio = aAudio
        aAudio.relevantTile = newTile
        
        do {
            try managedObjectContext.save()
        } catch {
            return
        }
    }
    

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
    
    func voiceRecordingMicrophoneTapped() {
        if audioRecorder == nil {
            self.recordingVoice = true
            startRecording()
        } else {
            self.recordingVoice = false
            finishRecording()
        }
    }
    

    func finishRecording() {
        audioRecorder.stop()
        audioRecorder = nil
        self.recordingVoice = false
    }
    
    func startRecording() {
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            // Delete the temporary file at
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
}
