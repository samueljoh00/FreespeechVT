//
//  UserData.swift
//  FreespeechVT
//
//  Created by Samuel Oh on 2/22/22.
//
 
import Combine
import SwiftUI
 
final class UserData: ObservableObject {
    
    @Published var wordsList = wordsStructList
    
    @Published var searchableOrderedWordsList = orderedSearchableWordsList
 
}
 

