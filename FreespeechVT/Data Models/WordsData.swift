//
//  CountriesData.swift
//  Countries
//
//  Created by Osman Balci on 8/2/20.
//  Copyright © 2020 Osman Balci. All rights reserved.
//
 
import Foundation
import SwiftUI
 
// Global array of Country structs
var wordsStructList = [Word]()
 
/*
 Each orderedSearchableCountriesList element contains
 selected country attributes separated by vertical lines
 for inclusion in the search by the Search Bar in FavoritesList:
      "id|name|alpha2code|capital|languages|currency"
 */
var orderedSearchableWordsList = [String]()
 
/*
 *********************************
 MARK: - Read Countries Data Files
 *********************************
 */
public func readWordsDataFiles() {
   
    var documentDirectoryHasFiles = false
    let wordsDataFullFilename = "WordsData.json"
   
    // Obtain URL of the CountriesData.json file in document directory on the user's device
    // Global constant documentDirectory is defined in UtilityFunctions.swift
    let urlOfJsonFileInDocumentDirectory = documentDirectory.appendingPathComponent(wordsDataFullFilename)
 
    do {
        /*
         Try to get the contents of the file. The left hand side is
         suppressed by using '_' since we do not use it at this time.
         Our purpose is just to check to see if the file is there or not.
         */
 
        _ = try Data(contentsOf: urlOfJsonFileInDocumentDirectory)
       
        /*
         If 'try' is successful, it means that the CountriesData.json
         file exists in document directory on the user's device.
         ---
         If 'try' is unsuccessful, it throws an exception and
         executes the code under 'catch' below.
         */
       
        documentDirectoryHasFiles = true
       
        /*
         --------------------------------------------------
         |   The app is being launched after first time   |
         --------------------------------------------------
         The CountriesData.json file exists in document directory on the user's device.
         Load it from Document Directory into countryStructList.
         */
       
        // The function is given in UtilityFunctions.swift
        wordsStructList = decodeJsonFileIntoArrayOfStructs(fullFilename: wordsDataFullFilename, fileLocation: "Document Directory")
        print("WordsData is loaded from document directory")
       
    } catch {
        documentDirectoryHasFiles = false
       
        /*
         ----------------------------------------------------
         |   The app is being launched for the first time   |
         ----------------------------------------------------
         The CountriesData.json file does not exist in document directory on the user's device.
         Load it from main bundle (project folder) into countryStructList.
        
         This catch section will be executed only once when the app is launched for the first time
         since we write and read the files in document directory on the user's device after first use.
         */
       
        // The function is given in UtilityFunctions.swift
        wordsStructList = decodeJsonFileIntoArrayOfStructs(fullFilename: wordsDataFullFilename, fileLocation: "Main Bundle")
        print("WordsData is loaded from main bundle")
       
        /*
         -------------------------------------------------------------
         |   Create global variable orderedSearchableCountriesList   |
         -------------------------------------------------------------
         This list has two purposes:
        
            (1) preserve the order of countries according to user's liking, and
            (2) enable search of selected country attributes by the SearchBar in FavoritesList.
        
         Each list element consists of "id|name|alpha2code|capital|languages|currency".
         We chose these attributes separated by vertical lines to be included in the search.
         We separate them with "|" so that we can extract its components separately.
         For example, to obtain the id: list item.components(separatedBy: "|")[0]
         */
        for word in wordsStructList {
            let selectedWordAttributesForSearch = "\(word.id)|\(word.name)|\(word.imageUrl)|\(word.color)|\(word.inGrid)"
           
            orderedSearchableWordsList.append(selectedWordAttributesForSearch)
        }
       
    }   // End of do-catch
   
    /*
    ----------------------------------------
    Read OrderedSearchableCountriesList File
    ----------------------------------------
    */
    if documentDirectoryHasFiles {
        // Obtain URL of the file in document directory on the user's device
        let urlOfFileInDocDir = documentDirectory.appendingPathComponent("OrderedSearchableWordsList")
       
        // Instantiate an NSArray object and initialize it with the contents of the file
        let arrayFromFile: NSArray? = NSArray(contentsOf: urlOfFileInDocDir)
       
        if let arrayObtained = arrayFromFile {
            // Store the unique id of the created array into the global variable
            orderedSearchableWordsList = arrayObtained as! [String]
        } else {
            print("OrderedSearchableWordsList file is not found in document directory on the user's device!")
        }
    }
}
 
/*
 ********************************************************
 MARK: - Write Countries Data Files to Document Directory
 ********************************************************
 */
public func writeWordsDataFiles() {
    /*
    --------------------------------------------------------------------------
    Write countryStructList into CountriesData.json file in Document Directory
    --------------------------------------------------------------------------
    */
   
    // Obtain URL of the JSON file into which data will be written
    let urlOfJsonFileInDocumentDirectory: URL? = documentDirectory.appendingPathComponent("WordsData.json")
 
    // Encode countryStructList into JSON and write it into the JSON file
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(wordsStructList) {
        do {
            try encoded.write(to: urlOfJsonFileInDocumentDirectory!)
        } catch {
            fatalError("Unable to write encoded words data to document directory!")
        }
    } else {
        fatalError("Unable to encode words data!")
    }
   
    /*
    ------------------------------------------------------
    Write orderedSearchableCountriesList into a file named
    OrderedSearchableCountriesList in Document Directory
    ------------------------------------------------------
    */
 
    // Obtain URL of the file in document directory on the user's device
    let urlOfFileInDocDirectory = documentDirectory.appendingPathComponent("OrderedSearchableWordsList")
 
    /*
    Swift Array does not yet provide the 'write' function, but NSArray does.
    Therefore, typecast the Swift array as NSArray so that we can write it.
    */
   
    (orderedSearchableWordsList as NSArray).write(to: urlOfFileInDocDirectory, atomically: true)
   
    /*
     The flag "atomically" specifies whether the file should be written atomically or not.
    
     If flag atomically is TRUE, the file is first written to an auxiliary file, and
     then the auxiliary file is renamed as OrderedSearchableCountriesList.
    
     If flag atomically is FALSE, the file is written directly to OrderedSearchableCountriesList.
     This is a bad idea since the file can be corrupted if the system crashes during writing.
    
     The TRUE option guarantees that the file will not be corrupted even if the system crashes during writing.
     */
}
 
 
 
 
 

