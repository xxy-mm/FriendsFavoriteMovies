//
//  FriendDetail.swift
//  FriendsFavoriteMovies
//
//  Created by Darian Mitchell  on 2024/4/19.
//

import SwiftUI
import SwiftData

struct FriendDetail: View {
    @Bindable var friend: Friend
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \Movie.title) private var movies: [Movie]
    
    var isNew: Bool
    
    init(friend: Friend, isNew: Bool = false){
        self.friend = friend
        self.isNew = isNew
    }
    
    
    var body: some View {
        Form {
            HStack {
                Text("Name")
                TextField("Friend Name", text: $friend.name)
                    .autocorrectionDisabled()
                    .multilineTextAlignment(.trailing)
            }
            Picker("Favorite Movie", selection: $friend.favoriteMovie) {
                Text("None")
                    .tag(nil as Movie?)
                ForEach(movies) { movie in
                    Text(movie.title).tag(movie as Movie?)
                }
            }.pickerStyle(.navigationLink)
        }
        .navigationTitle(isNew ? "New Friend" : "Friend")
        .toolbar{
            if isNew {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done", action: addFriend)
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func addFriend() {
        guard !friend.name.isEmptyString else {
            return
        }
        modelContext.insert(friend)
        dismiss()
    }
}

#Preview {
    NavigationStack {
        FriendDetail(friend: SampleData.shared.friend)
            .modelContainer(SampleData.shared.modelContainer)
    }
}

#Preview("New Friend") {
    NavigationStack {
        FriendDetail(friend: SampleData.shared.friend, isNew: true)
            .modelContainer(SampleData.shared.modelContainer)
    }
}
