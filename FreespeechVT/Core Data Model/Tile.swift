//
//  Tile.swift
//  Tile
//
//  Created by Andy Cho on 2/22/22.
//  Copyright © 2022 FreespeechVT. All rights reserved.
//

import Foundation
import CoreData
import SwiftUI

public class Tile: NSManagedObject, Identifiable {
    
    @NSManaged public var word: String?
    
}

extension Tile {
    static func allTilesFetchRequest() -> NSFetchRequest<Tile> {
        let fetchRequest = NSFetchRequest<Tile>(entityName: "Tile")
        
        // List the fetched park visits in alphabetical order with respect to park visit full name.
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "word", ascending: true)]
        
        return fetchRequest
    }
}
