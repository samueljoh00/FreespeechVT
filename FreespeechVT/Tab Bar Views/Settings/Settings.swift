//
//  Settings.swift
//  Settings
//
//  Created by Andy Cho on 3/9/22.
//  Copyright © 2022 FreespeechVT. All rights reserved.
//
//
//  Settings.swift
//  Settings
//
//  Created by Andy Cho on 10/12/21.
//  Copyright © 2021 Andy Cho. All rights reserved.
//

import Foundation
import SwiftUI

struct Settings: View {
    
    @State private var showEnteredValues = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("")) {
                    NavigationLink(destination: AddTile()) {
                        HStack {
                            Image(systemName: "pencil.circle")
                                .imageScale(.medium)
                                .font(Font.title.weight(.light))
                                .foregroundColor(.blue)
                            Text("Add Tile")
                        }
                    }
                }
            }   // End of Form
            // Set font and size for the whole Form content
            .font(.system(size: 14))
            .navigationBarTitle(Text("Settings"), displayMode: .inline)
            
        }   // End of NavigationView
        .navigationViewStyle(StackNavigationViewStyle())
        
    }   // End of var
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}

