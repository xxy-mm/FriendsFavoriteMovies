//
//  Item.swift
//  FriendsFavoriteMovies
//
//  Created by Darian Mitchell  on 2024/4/18.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
