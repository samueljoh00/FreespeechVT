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
    
    public func customNavigationViewStyle() -> some View {
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            // Use single column navigation view for iPhone
            return AnyView(navigationViewStyle(StackNavigationViewStyle()))
        } else {
            // Use double column navigation view for iPad
            return AnyView(self
                .navigationViewStyle(DoubleColumnNavigationViewStyle())
                .padding(.leading, 1)  // Workaround to show master view until Apple fixes the bug
            )
        }
    }
    
}
