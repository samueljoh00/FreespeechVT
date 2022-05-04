//
//  WordsData.swift
//  FreespeechVT
//
//  Created by Samuel Oh on 2/22/22.
//
 
import Foundation
import SwiftUI
import CoreData

/*
 * Populates tile database and holds struct list for default tiles
 */
 
fileprivate var wordsStructList = [Word]()

/*
 Create Tiles Database
 */
public func createTilesDatabse() {

    wordsStructList = decodeJsonFileIntoArrayOfStructs(fullFilename: "WordsData.json", fileLocation: "Main Bundle")
    
    populateDatabase()
}


// Populate the database if not already done
func populateDatabase() {
    
    let managedObjectContext = PersistenceController.shared.persistentContainer.viewContext
    
    let fetchRequest = NSFetchRequest<Tile>(entityName: "Tile")
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "word", ascending: true)]
    
    var listOfAllTileEntitiesInDatabase = [Tile]()
    
    do {
        listOfAllTileEntitiesInDatabase = try managedObjectContext.fetch(fetchRequest)
    } catch {
        print("Populate Database Failed!")
        return
    }
    
    if listOfAllTileEntitiesInDatabase.count > 0 {
        print("Database has already been populated!")
        return
    }
    
    print("Database will be populated!")
    
    for aTile in wordsStructList {
        let tileEntity = Tile(context: managedObjectContext)
        
        tileEntity.word = aTile.name

        let photoEntity = Photo(context: managedObjectContext)
        
        let photoUIImage = UIImage(named: aTile.imageUrl)
        
        let photoData = photoUIImage?.jpegData(compressionQuality: 1.0)
        
        photoEntity.tilePhoto = photoData!
        
        tileEntity.photo = photoEntity
        photoEntity.tile = tileEntity
        
        
        // Save into core data
        do {
            try managedObjectContext.save()
        } catch {
            return
        }
    }
}

