//
//  MovieList.swift
//  FriendsFavoriteMovies
//
//  Created by Darian Mitchell  on 2024/4/18.
//

import SwiftData
import SwiftUI

struct MovieList: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var movies: [Movie]

    @State private var newMovie: Movie?

    init(titleFilter: String = "", sortBy: FilteredMovieList.SortBy = .title) {
        let predicate = #Predicate<Movie> { movie in
            titleFilter.isEmptyString || movie.title.localizedStandardContains(titleFilter)
        }

        _movies = sortBy == .title ? Query(filter: predicate, sort: \Movie.title) :
            Query(filter: predicate, sort: \Movie.releaseDate)
    }

    var body: some View {
        Group {
            if !movies.isEmpty {
                List {
                    ForEach(movies) { movie in
                        NavigationLink {
                            MovieDetail(movie: movie)
                        } label: {
                            Text(movie.title)
                        }
                    }
                    .onDelete(perform: deleteMovies)
                }
            } else {
                ContentUnavailableView {
                    Label("No Movies", systemImage: "film.stack")
                }
            }
        }
        .navigationTitle("Movies")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
            ToolbarItem {
                Button(action: addMovie) {
                    Label("Add Movie", systemImage: "plus")
                }
            }
        }
        .sheet(item: $newMovie) { movie in
            NavigationStack {
                MovieDetail(movie: movie, isNew: true)
            }
        }
    }

    private func addMovie() {
        withAnimation {
            let newItem = Movie(title: "", releaseDate: .now)
            newMovie = newItem
        }
    }

    private func deleteMovies(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(movies[index])
            }
        }
    }
}

#Preview {
    NavigationStack {
        MovieList()
            .modelContainer(SampleData.shared.modelContainer)
    }
}

#Preview("Movie by Date") {
    NavigationStack {
        MovieList(sortBy: .releaseDate)
            .modelContainer(SampleData.shared.modelContainer)
    }
}
#Preview("Empty List") {
    NavigationStack {
        MovieList()
            .modelContainer(for: Movie.self, inMemory: true)
    }
}

#Preview("Filtered Movieds") {
    NavigationStack {
        MovieList(titleFilter: "cat")
            .modelContainer(SampleData.shared.modelContainer)
    }
}
