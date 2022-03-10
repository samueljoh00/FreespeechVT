//
//  Audio.swift
//  Audio
//
//  Created by Andy Cho on 2/22/22.
//  Copyright © 2022 FreespeechVT. All rights reserved.
//

import Foundation
import CoreData

public class Photo: NSManagedObject, Identifiable {
    @NSManaged public var tilePhoto: Data?
    @NSManaged public var tile: Tile?
}


