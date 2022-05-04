//
//  WordStruct.swift
//  FreespeechVT
//
//  Created by Samuel Oh on 2/22/22.
//
 
import SwiftUI

/* Word data model for our default tiles */
 
struct Word: Hashable, Codable, Identifiable {
   
    var id: UUID
    var name: String
    var imageUrl: String
    var color: String
    var inGrid: Bool
}

