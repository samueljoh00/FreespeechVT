//
//  UserData.swift
//  Countries
//
//  Created by Osman Balci on 9/15/20.
//  Copyright © 2020 Osman Balci. All rights reserved.
//
 
import Combine
import SwiftUI
 
final class UserData: ObservableObject {
    
    @Published var wordsList = wordsStructList
    
    @Published var searchableOrderedWordsList = orderedSearchableWordsList
 
}
 

