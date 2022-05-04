//
//  Tile.swift
//  Tile
//
//  Created by Andy Cho on 2/22/22.
//  Copyright © 2022 FreespeechVT. All rights reserved.
//

/*
 * Structure of our tile data
 */

import Foundation
import CoreData
import SwiftUI

public class Tile: NSManagedObject, Identifiable {
    
    @NSManaged public var word: String?
    @NSManaged public var color: UIColor?
    @NSManaged public var frequency: Bool
    @NSManaged public var photo: Photo?
    @NSManaged public var audio: Audio?
}

extension Tile {
    // Fetches all tiles
    static func allTilesFetchRequest() -> NSFetchRequest<Tile> {
        let fetchRequest = NSFetchRequest<Tile>(entityName: "Tile")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "word", ascending: true)]
        
        return fetchRequest
    }
}
