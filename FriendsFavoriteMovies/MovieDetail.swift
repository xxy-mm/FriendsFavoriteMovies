//
//  MovieDetail.swift
//  FriendsFavoriteMovies
//
//  Created by Darian Mitchell  on 2024/4/18.
//

import SwiftData
import SwiftUI
struct MovieDetail: View {
    @Bindable var movie: Movie
    @Query(sort: \Friend.name) private var friends: [Friend]
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    private var isNew: Bool
    @State private var isAddingFriend = false
    @State private var selectedFriend: Friend?
    init(movie: Movie, isNew: Bool = false) {
        self.movie = movie
        self.isNew = isNew
    }

    var sortedFrieds: [Friend] {
        movie.favoritedBy.sorted { $0.name < $1.name }
    }

    var body: some View {
        Form {
            TextField("Movie title", text: $movie.title)
                .autocorrectionDisabled()
            DatePicker("Release date", selection: $movie.releaseDate, displayedComponents: .date)

            Section {
                ForEach(sortedFrieds) { friend in
                    Text(friend.name)
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        modelContext.delete(sortedFrieds[index])
                    }
                }
            } header: {
                HStack {
                    Text("Favorited by")
                    Spacer()
                    Button {
                        isAddingFriend = true
                    } label: {
                        Image(systemName: "plus")
                            .accessibilityLabel("Add Friend")
                    }
                }
            }
        }
        .navigationTitle(isNew ? "New Movie" : "Movie")
        .toolbar {
            if isNew {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        guard !movie.title.isEmptyString else {
                            return
                        }
                        modelContext.insert(movie)
                        dismiss()
                    }
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .sheet(isPresented: $isAddingFriend, content: {
            NavigationStack {
                Picker("Select a Friend", selection: $selectedFriend) {
                    Text("None").tag(nil as Friend?)
                    ForEach(friends) { friend in
                        Text(friend.name).tag(friend as Friend?)
                    }
                }
                .pickerStyle(.inline)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") {
                            if let selectedFriend {
                                movie.favoritedBy.append(selectedFriend)
                                try? modelContext.save()
                            }
                            isAddingFriend = false
                        }
                    }
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            isAddingFriend = false
                        }
                    }
                }
                
            }
            .interactiveDismissDisabled()
        })
        
        
    }
}

#Preview {
    NavigationStack {
        MovieDetail(movie: SampleData.shared.movie)
    }
    .modelContainer(SampleData.shared.modelContainer)
}

#Preview("New Movie") {
    NavigationStack {
        MovieDetail(movie: SampleData.shared.movie, isNew: true)
            .navigationBarTitleDisplayMode(.inline)
    }
    .modelContainer(SampleData.shared.modelContainer)
}
