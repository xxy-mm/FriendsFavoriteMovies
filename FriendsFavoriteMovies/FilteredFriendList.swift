//
//  FilteredFriendList.swift
//  FriendsFavoriteMovies
//
//  Created by Darian Mitchell  on 2024/4/20.
//

import SwiftUI

struct FilteredFriendList: View {
    @State private var filteredText = ""
    
    var body: some View {
        NavigationSplitView {
            FriendList(filteredName: filteredText)
                .searchable(text: $filteredText)
        } detail: {
            Text("Select a friend")
                .navigationTitle("Friend")
        }
    }
}

#Preview {
    FilteredFriendList()
        .modelContainer(SampleData.shared.modelContainer)
}
