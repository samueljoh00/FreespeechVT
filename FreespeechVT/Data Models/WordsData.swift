//
//  WordsData.swift
//  FreespeechVT
//
//  Created by Samuel Oh on 2/22/22.
//
 
import Foundation
import SwiftUI
import CoreData
 
fileprivate var wordsStructList = [Word]()

/*
 ***********************************
 MARK: Create Tiles Database
 ***********************************
 */
public func createTilesDatabse() {

    wordsStructList = decodeJsonFileIntoArrayOfStructs(fullFilename: "WordsData.json", fileLocation: "Main Bundle")
    
    populateDatabase()
}

/*
*********************************************
MARK: Populate Database If Not Already Done
*********************************************
*/
func populateDatabase() {
    
    // ❎ Get object reference of CoreData managedObjectContext from the persistent container
    let managedObjectContext = PersistenceController.shared.persistentContainer.viewContext
    
    //----------------------------
    // ❎ Define the Fetch Request
    //----------------------------
    let fetchRequest = NSFetchRequest<Tile>(entityName: "Tile")
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "word", ascending: true)]
    
    var listOfAllTileEntitiesInDatabase = [Tile]()
    
    do {
        //-----------------------------
        // ❎ Execute the Fetch Request
        //-----------------------------
        listOfAllTileEntitiesInDatabase = try managedObjectContext.fetch(fetchRequest)
    } catch {
        print("Populate Database Failed!")
        return
    }
    
    if listOfAllTileEntitiesInDatabase.count > 0 {
        // Database has already been populated
        print("Database has already been populated!")
        return
    }
    
    print("Database will be populated!")
    
    for aTile in wordsStructList {
        /*
         ======================================================
         Create an instance of the Album Entity and dress it up
         ======================================================
        */
        
        // ❎ Create an instance of the Album entity in CoreData managedObjectContext
        let tileEntity = Tile(context: managedObjectContext)
        
        // ❎ Dress it up by specifying its attributes
        tileEntity.word = aTile.name
        

        /*
         ======================================================
         Create an instance of the Photo Entity and dress it up
         ======================================================
         */
        
        // ❎ Create an instance of the Photo Entity in CoreData managedObjectContext
        let photoEntity = Photo(context: managedObjectContext)
        
        // Obtain the album cover photo image from Assets.xcassets as UIImage
        // LOOK HERE FOR THE SETTING OF IMAGE URL
        let photoUIImage = UIImage(named: aTile.imageUrl)
        
        // Convert photoUIImage to data of type Data (Binary Data) in JPEG format with 100% quality
        let photoData = photoUIImage?.jpegData(compressionQuality: 1.0)
        
        // Assign photoData to Core Data entity attribute of type Data (Binary Data)
        photoEntity.tilePhoto = photoData!
        
        /*
         ==============================
         Establish Entity Relationships
         ==============================
        */
        
        // ❎ Establish One-to-One relationship between Contact and Photo
        tileEntity.photo = photoEntity      // A Contact can have only one photo
        photoEntity.tile = tileEntity      // A photo can belong to only one album
        
        /*
         ==================================
         Save Changes to Core Data Database
         ==================================
        */
        
        // ❎ CoreData Save operation
        do {
            try managedObjectContext.save()
        } catch {
            return
        }
        
    }   // End of for loop

}

