//
//  TileItem.swift
//  TileItem
//
//  Created by Andy Cho on 4/26/22.
//  Copyright © 2022 FreespeechVT. All rights reserved.
//

import Foundation
import SwiftUI
/* Our display for each tile word in the edit list */
struct TileItem: View {
    
    let tile: Tile
    
    @FetchRequest(fetchRequest: Tile.allTilesFetchRequest()) var allTiles: FetchedResults<Tile>
    
    var body: some View {
        HStack {
            getImageFromBinaryData(binaryData: tile.photo!.tilePhoto!, defaultFilename: "")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80.0, height: 60.0)
            
            Text(tile.word ?? "")
                .font(.system(size: 14))
        }
    }
}
