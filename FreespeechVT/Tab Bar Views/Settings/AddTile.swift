//
//  AddTile.swift
//  AddTile
//
//  Created by Andy Cho on 3/9/22.
//  Copyright © 2022 FreespeechVT. All rights reserved.
//

import Foundation
import SwiftUI

struct AddTile: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State private var showTileAddedAlert = false
    @State private var showInputDataMissingAlert = false
    
    var photoTakeOrPickChoices = ["Camera", "Photo Library"]
    @State private var showImagePicker = false
    @State private var photoImageData: Data? = nil
    @State private var photoTakeOrPickIndex = 1
    
    @State private var word = "" //
    
    var body: some View {
        Form {
            Section(header: Text("Word")) {
                HStack {
                    TextField("Enter Word", text: $word)
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
            Section(header: Text("Tile Photo")) {
                photoImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100.0, height: 100.0)
                Spacer()
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
    
    var photoImage: Image {
        if let imageData = photoImageData {
            // The public function is given in UtilityFunctions.swift
            let imageView = getImageFromBinaryData(binaryData: imageData, defaultFilename: "ImageUnavailable")
            return imageView
        } else {
            return Image("ImageUnavailable")
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
    var tileAddedAlert: Alert {
        Alert(title: Text("Tile Added!"),
              message: Text("New tile is added to your tile grid!"),
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
        let newTile = Tile(context: managedObjectContext)
        
        // ❎ Dress up the new Album entity
        newTile.word = word
        
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
        
        /*
         ==============================
         Establish Entity Relationships
         ==============================
        */
        
        // Establish One-to-One Relationship between Album and Photo
        newTile.photo = newPhoto    // An album can have only one photo
        newPhoto.tile = newTile    // A photo can belong to only one album
        
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
}
