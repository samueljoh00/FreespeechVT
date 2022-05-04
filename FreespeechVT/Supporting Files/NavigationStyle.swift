//
//  NavigationStyle.swift
//  NavigationStyle
//
//  Created by Andy Cho on 4/27/22.
//  Copyright © 2022 FreespeechVT. All rights reserved.
//

import Foundation
import SwiftUI

extension View {
    
    // Custom setting for when user navigates through pages
    public func customNavigationViewStyle() -> some View {
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            return AnyView(navigationViewStyle(StackNavigationViewStyle()))
        } else {
            return AnyView(self
                .navigationViewStyle(DoubleColumnNavigationViewStyle())
                .padding(.leading, 1)
            )
        }
    }
    
}
