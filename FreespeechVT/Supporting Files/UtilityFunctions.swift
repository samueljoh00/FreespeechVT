//
//  UtilityFunctions.swift
//  FreespeechVT
//
//  Created by Samuel Oh on 2/22/22.
//
 
import Foundation
import SwiftUI
 
// Global constant
let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
 
// Decodes our JSON file into an array of structs
public func decodeJsonFileIntoArrayOfStructs<T: Decodable>(fullFilename: String, fileLocation: String, as type: T.Type = T.self) -> T {
   
    var jsonFileData: Data?
    var jsonFileUrl: URL?
    var arrayOfStructs: T?
   
    if fileLocation == "Main Bundle" {
        let urlOfJsonFileInMainBundle: URL? = Bundle.main.url(forResource: fullFilename, withExtension: nil)
       
        if let mainBundleUrl = urlOfJsonFileInMainBundle {
            jsonFileUrl = mainBundleUrl
        } else {
            print("JSON file \(fullFilename) does not exist in main bundle!")
        }
    } else {
        let urlOfJsonFileInDocumentDirectory: URL? = documentDirectory.appendingPathComponent(fullFilename)
       
        if let docDirectoryUrl = urlOfJsonFileInDocumentDirectory {
            jsonFileUrl = docDirectoryUrl
        } else {
            print("JSON file \(fullFilename) does not exist in document directory!")
        }
    }
   
    do {
        jsonFileData = try Data(contentsOf: jsonFileUrl!)
    } catch {
        print("Unable to obtain JSON file \(fullFilename) content!")
    }
   
    do {
        let decoder = JSONDecoder()
       
        arrayOfStructs = try decoder.decode(T.self, from: jsonFileData!)
    } catch {
        print("Unable to decode JSON file \(fullFilename)!")
    }
   
    return arrayOfStructs!
}

// Retrieves image from binary data
public func getImageFromBinaryData(binaryData: Data?, defaultFilename: String) -> Image {
    let uiImage = UIImage(data: binaryData!)
   
    if let imageObtained = uiImage {
       
        return Image(uiImage: imageObtained)
       
    } else {
        return Image(defaultFilename)
    }
}

