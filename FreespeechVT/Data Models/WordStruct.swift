//
//  WordStruct.swift
//  FreespeechVT
//
//  Created by Samuel Oh on 2/22/22.
//
 
import SwiftUI
 
struct Word: Hashable, Codable, Identifiable {
   
    var id: UUID        // Storage Type: String, Use Type (format): UUID
    var name: String
    var imageUrl: String
    var color: String
    var inGrid: Bool
}

