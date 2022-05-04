//
//  Persistence.swift
//  FreespeechVT
//
//  Created by Samuel Oh on 2/15/22.
//

/*
 * Persistence controller maintains data of our core data model
 */

import CoreData

struct PersistenceController {
    /*
     'shared' is the class variable holding the object reference of the newly created PersistenceController object.
     It is referenced in any project file as PersistenceController.shared
     */
    static let shared = PersistenceController()

    // Property of the PersistenceController.shared instance
    let persistentContainer: NSPersistentContainer

    init(inMemory: Bool = false) {
        
        persistentContainer = NSPersistentContainer(name: "FreespeechVT")
        
        if inMemory {
            persistentContainer.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }

    // Saves current life cycle
    func saveContext () {
        let managedObjectContext: NSManagedObjectContext = PersistenceController.shared.persistentContainer.viewContext
        
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

