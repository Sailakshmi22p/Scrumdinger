//
//  ScrumdingerApp.swift
//  Scrumdinger
//
//  Created by Sai Lakshmi on 5/8/22.
//

import SwiftUI

@main
struct ScrumdingerApp: App {
    ///you’ll create the source of truth for your app’s data by adding a @State property to ScrumdingerApp
    ///Then, you’ll pass a binding to that data down the hierarchy to the list view.
    ///@State private var scrums = DailyScrum.sampleData
    
    //The @StateObject property wrapper creates a single instance of an observable object for each instance of the structure that declares it.
    @StateObject private var store = ScrumStore()
    var body: some Scene {
        WindowGroup {
            ///set ScrumsView as the initial view for the app.
            NavigationView {
                ScrumsView(scrums: $store.scrums) {
                    Task {
                        do {
                            try await ScrumStore.save(scrums: store.scrums)
                        } catch {
                            fatalError("Error saving scrums.")
                        }
                    }
                }
            }
            .task {
                do {
                    store.scrums = try await ScrumStore.load()
                } catch {
                    fatalError("Error loading scrums.")
                }
            }
        }
    }
}
