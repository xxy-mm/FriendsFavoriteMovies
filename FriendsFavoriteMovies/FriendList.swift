//
//  FriendList.swift
//  FriendsFavoriteMovies
//
//  Created by Darian Mitchell  on 2024/4/19.
//

import SwiftData
import SwiftUI

struct FriendList: View {
    @Query(sort: \Friend.name) private var friends: [Friend]
    @Environment(\.modelContext) private var modelContext
    @State private var newFriend: Friend?
    
    
    init(filteredName: String = ""){
        let predicate = #Predicate<Friend> { friend in
            filteredName.isEmptyString || friend.name.localizedStandardContains(filteredName)
        }
        
        _friends = Query(filter: predicate, sort: \Friend.name)
    }
    var body: some View {
        
            Group {
                if !friends.isEmpty {
                    List {
                        ForEach(friends) { friend in
                            NavigationLink(friend.name) {
                                FriendDetail(friend: friend)
                            }
                        }
                        .onDelete(perform: deleteFriends)
                    }
                } else {
                    ContentUnavailableView {
                        Label("No Friends", systemImage: "person.and.person")
                    }
                }
            }
            .navigationTitle("Friends")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addFriend) {
                        Label("Add Friend", systemImage: "plus")
                    }
                }
            }
            .sheet(item: $newFriend, onDismiss: onDismiss) { newFriend in
                NavigationStack {
                    FriendDetail(friend: newFriend, isNew: true)
                }
                .interactiveDismissDisabled()
            }
    }

    private func addFriend() {
        withAnimation {
            newFriend = Friend(name: "")
        }
    }

    private func onDismiss() {
        newFriend = nil
    }

    private func deleteFriends(_ indexSet: IndexSet) {
        withAnimation {
            for index in indexSet {
                modelContext.delete(friends[index])
            }
        }
    }
}

#Preview {
    NavigationStack {
        FriendList()
            .modelContainer(SampleData.shared.modelContainer)
    }
}

#Preview("No Friends") {
    NavigationStack {
        FriendList()
            .modelContainer(for: Friend.self, inMemory: true)
    }
}
