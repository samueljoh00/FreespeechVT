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

struct EditTile: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: Tile.allTilesFetchRequest()) var allTiles: FetchedResults<Tile>
    
    let currTile: Tile
    
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
        NavigationView {
            Form {
                Section(header: Text("Word")) {
                    HStack {
                        TextField("Enter Word", text: $word)
                            .onAppear {
                                self.word = currTile.word ?? ""
                            }
                            .textFieldStyle(RoundedBorderTextFieldStyle())
    //                        .frame(width: 500, height: 36)
                        
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
            .alert(isPresented: $showTileDeleted, content: { tileDeleted })
        }
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .autocapitalization(.words)
        .disableAutocorrection(true)
        .font(.system(size: 14))
        .alert(isPresented: $showInputDataMissingAlert, content: { inputDataMissingAlert })
        .alert(isPresented: $showTileEditedAlert, content: { tileEditedAlert })
        .sheet(isPresented: $showImagePicker) {
            /*
             🔴 We pass $showImagePicker and $photoImageData with $ sign into PhotoCaptureView
             so that PhotoCaptureView can change them. The @Binding keywork in PhotoCaptureView
             indicates that the input parameter is passed by reference and is changeable (mutable).
             */
            PhotoCaptureView(showImagePicker: $showImagePicker,
                             photoImageData: $photoImageData,
                             cameraOrLibrary: photoTakeOrPickChoices[photoTakeOrPickIndex])
        }
    }
    
    /*
     --------------------------------
     MARK: Input Data Missing Alert
     --------------------------------
     */
    var inputDataMissingAlert: Alert {
        Alert(title: Text("Missing Input Data!"),
              message: Text("Missing word input"),
              dismissButton: .default(Text("OK")) )
    }
    
    /*
     -----------------------
     MARK: Tile Added Alert
     -----------------------
     */
    var tileEditedAlert: Alert {
        Alert(title: Text("Tile Edited!"),
              message: Text("Updated tile is added to your tile grid!"),
              dismissButton: .default(Text("OK")) {
                  // Dismiss this View and go back
                  presentationMode.wrappedValue.dismiss()
            })
    }
    
    func inputDataValidated() -> Bool {
        if word.isEmpty {
            return false
        }
        
        return true
    }
    
    func saveTile() {
        /*
         ======================================================
         Create an instance of the Tile Entity and dress it up
         ======================================================
        */
        
        // ❎ Create a new Album entity in CoreData managedObjectContext
        let newTile = currTile
        
        // ❎ Dress up the new Album entity
        newTile.word = word
        newTile.color = colorStorage[colorIndex]
        newTile.frequency = frequentWord
        
        /*
         ======================================================
         Create an instance of the Photo Entity and dress it up
         ======================================================
        */
        
        // ❎ Create a new Photo entity in CoreData managedObjectContext
        let newPhoto = Photo(context: managedObjectContext)
        
        // ❎ Dress up the new Photo entity
        if let imageData = photoImageData {
            newPhoto.tilePhoto = imageData
        } else {
            // Obtain the album cover default image from Assets.xcassets as UIImage
            let photoUIImage = UIImage(named: "ImageUnavailable")
            
            // Convert photoUIImage to data of type Data (Binary Data) in JPEG format with 100% quality
            let photoData = photoUIImage?.jpegData(compressionQuality: 1.0)
            
            // Assign photoData to Core Data entity attribute of type Data (Binary Data)
            newPhoto.tilePhoto = photoData!
        }
        let aAudio = Audio(context: self.managedObjectContext)
        
        // ❎ Dress it up by specifying its attribute
        do {
            // Try to get the audio file data from audioFileUrl
            aAudio.voiceRecording = try Data(contentsOf: temporaryAudioFileUrl, options: NSData.ReadingOptions.mappedIfSafe)
            
        } catch {
            aAudio.voiceRecording = nil
        }
        
        /*
         ==============================
         Establish Entity Relationships
         ==============================
        */
        
        // Establish One-to-One Relationship between Album and Photo
        newTile.photo = newPhoto    // An album can have only one photo
        newPhoto.tile = newTile    // A photo can belong to only one album
        newTile.audio = aAudio
        aAudio.relevantTile = newTile
        
        /*
         ===========================================
         MARK: ❎ Save Changes to Core Data Database
         ===========================================
         */
        
        do {
            try managedObjectContext.save()
        } catch {
            return
        }
    }
    
    /*
     ----------------------------------------
     MARK: - Voice Recording Microphone Label
     ----------------------------------------
     */
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
    
    /*
     ---------------------------------------
     MARK: Voice Recording Microphone Tapped
     ---------------------------------------
     */
    func voiceRecordingMicrophoneTapped() {
        if audioRecorder == nil {
            self.recordingVoice = true
            startRecording()
        } else {
            self.recordingVoice = false
            finishRecording()
        }
    }
    
    /*
     ----------------------------------
     MARK: Finish Voice Notes Recording
     ----------------------------------
     */
    func finishRecording() {
        audioRecorder.stop()
        audioRecorder = nil
        self.recordingVoice = false
    }
    
    /*
     ---------------------------------
     MARK: Start Voice Notes Recording
     ---------------------------------
     */
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
            // Take no action
        }
        
        do {
            audioRecorder = try AVAudioRecorder(url: temporaryAudioFileUrl, settings: settings)
            audioRecorder.record()
        } catch {
            finishRecording()
        }
    }
    
    var tileDeleted: Alert {
        Alert(title: Text("Tile Deleted!"),
              message: Text("The tile was deleted from the grid."),
              dismissButton: .default(Text("OK")) {
                  // Dismiss this View and go back
                  presentationMode.wrappedValue.dismiss()
            })
    }
    
}
