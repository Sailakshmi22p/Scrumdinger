//
//  ScrumsView.swift
//  Scrumdinger
//
//  Created by Sai Lakshmi on 5/13/22.
//

import SwiftUI

struct ScrumsView: View {
    @Binding var scrums: [DailyScrum]
    ///SwiftUI indicates the current operational state of your app’s Scene instances with a scenePhase Environment value.
    ///You’ll observe this value and save user data when it becomes inactive.
    @Environment(\.scenePhase) private var scenePhase
    ///The isPresentingNewScrumView property controls the presentation of the edit view to create a new scrum.
    @State private var isPresentingNewScrumView = false
    ///The newScrumData property is the source of truth for all the changes the user makes to the new scrum.
    @State private var newScrumData = DailyScrum.Data()
    ///You’ll provide the saveAction closure when instantiating ScrumsView.
    let saveAction: ()->Void
    
    var body: some View {
        List {
            //The $ prefix accesses the projected value of a wrapped property. The projected value of the scrums binding is another binding.
            ForEach($scrums) { $scrum in
                NavigationLink(destination: DetailView(scrum: $scrum)) {
                    CardView(scrum: scrum)
                }
                .listRowBackground(scrum.theme.mainColor)
            }
        }
        .navigationTitle("Daily Scrums")
        .toolbar {
            Button(action: {
                ///Changing isPresentingNewScrumView to true causes the app to present the sheet.
                isPresentingNewScrumView = true
            }) {
                Image(systemName: "plus")
            }
            .accessibilityLabel("New Scrum")
        }
        .sheet(isPresented: $isPresentingNewScrumView) {
            NavigationView {
                ///DetailEditView takes a binding to newScrumData, but the @State property in ScrumsView maintains the source of truth.
                DetailEditView(data: $newScrumData)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Dismiss") {
                                isPresentingNewScrumView = false
                                ///Resetting newScrumData ensures previous modifications aren’t visible if the user taps the Add button again.
                                newScrumData = DailyScrum.Data()
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Add") {
                                ///The properties of newScrumData are bound to the controls of DetailEditView and have the current information that the user set. The scrums array contains elements of DailyScrum, so you’ll need to create a new DailyScrum to insert into the array.
                                let newScrum = DailyScrum(data: newScrumData)
                                scrums.append(newScrum)
                                isPresentingNewScrumView = false
                            }
                        }
                    }
            }
        }
        
       /// You can use onChange(of:perform:) to trigger actions when a specified value changes.
        .onChange(of: scenePhase) { phase in
            ///A scene in the inactive phase no longer receives events and may be unavailable to the user.
            if phase == .inactive { saveAction() }
        }
    }
}

struct ScrumsView_Previews: PreviewProvider {
    static var previews: some View {
        //Adding the NavigationView displays navigation elements, like title and bar buttons, on the canvas.
        NavigationView {
            ScrumsView(scrums: .constant(DailyScrum.sampleData), saveAction: {})
        }
    }
}

