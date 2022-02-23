//
//  CountryStruct.swift
//  Countries
//
//  Created by Osman Balci on 5/27/20.
//  Copyright © 2020 Osman Balci. All rights reserved.
//
 
import SwiftUI
 
struct Word: Hashable, Codable, Identifiable {
   
    var id: UUID        // Storage Type: String, Use Type (format): UUID
    var name: String
    var imageUrl: String
    var color: String
    var inGrid: Bool
}
 
/*
 We create the Country structure above to represent a country
 JSON object with exactly the same attribute names.
 {
     "id": "4055D506-91C6-42F6-9AF3-715882650837",
     "name": "Argentina",
     "alpha2code": "AR",
     "flagImageUrl": "https://manta.cs.vt.edu/iOS/flags/ar.png",
     "capital": "Buenos Aires",
     "population": 45195774,
     "area": 2780400,
     "languages": "Spanish, Guaraní",
     "currency": "Argentine peso",
     "latitude": -38.416097,
     "longitude": -63.616672,
     "delta": 33.0,
     "deltaUnit": "degrees"
 }
 */
 

