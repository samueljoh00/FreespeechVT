//
//  Audio.swift
//  Audio
//
//  Created by Andy Cho on 2/22/22.
//  Copyright © 2022 FreespeechVT. All rights reserved.
//

import Foundation
import CoreData

public class Audio: NSManagedObject, Identifiable {
    @NSManaged public var voiceRecording: Data?
}


