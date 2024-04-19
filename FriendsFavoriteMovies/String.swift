//
//  String.swift
//  FriendsFavoriteMovies
//
//  Created by Darian Mitchell  on 2024/4/19.
//

import Foundation

extension String {
    var isEmptyString: Bool {
        self.trimmingCharacters(in: .whitespaces).isEmpty
    }
}
