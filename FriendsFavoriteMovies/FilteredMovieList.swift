//
//  FilteredMovieList.swift
//  FriendsFavoriteMovies
//
//  Created by Darian Mitchell  on 2024/4/20.
//

import SwiftUI

struct FilteredMovieList: View {
    enum SortBy{
        case title
        case releaseDate
    }
    
    @State private var searchText = ""
    @State private var sortByTitle = true
    
    var body: some View {
        NavigationSplitView {
            let sortBy = sortByTitle ? SortBy.title : SortBy.releaseDate
            
            MovieList(titleFilter: searchText, sortBy: sortBy)
                .searchable(text: $searchText)
                .toolbar(content: {
                    ToolbarItem(placement: .cancellationAction) {
                        let sortBy = sortByTitle ? "Title" : "Release Date"
                        Toggle("Sort by \(sortBy)", isOn: $sortByTitle)
                            .toggleStyle(.switch)
                            .labelsHidden()
                    }
                })
        } detail: {
            Text("Select an movie")
                .navigationTitle("Movie")
        }
    }
}

#Preview {
    FilteredMovieList()
        .modelContainer(SampleData.shared.modelContainer)
}
