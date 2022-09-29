//
//  ContentView.swift
//  Scrumdinger
//
//  Created by Sai Lakshmi on 5/8/22.
//

import SwiftUI
import AVFoundation

struct MeetingView: View {
    
    @Binding var scrum: DailyScrum
    ///Wrapping a property as a @StateObject means the view owns the source of truth for the object. @StateObject ties the ScrumTimer, which is an ObservableObject, to the MeetingView life cycle.
    @StateObject var scrumTimer = ScrumTimer()
    
    ///The Models > AVPlayer+Ding.swift file in the starter project defines the sharedDingPlayer object, which plays the ding.wav resource.
    private var player: AVPlayer {AVPlayer.sharedDingPlayer}
    
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 16.0)
                .fill(scrum.theme.mainColor)
            VStack {
                
                MeetingHeaderView(secondsElapsed: scrumTimer.secondsElapsed, secondsRemaining: scrumTimer.secondsRemaining, theme: scrum.theme)
                
                MeetingTimerView(speakers: scrumTimer.speakers, theme: scrum.theme)
                
                MeetingFooterView(speakers: scrumTimer.speakers, skipAction: scrumTimer.skipSpeaker)
            }
        }
        
        .padding()
        .foregroundColor(scrum.theme.accentColor)
        ///The timer resets each time an instance of MeetingView shows on screen, indicating that a meeting should begin.
        .onAppear {
            scrumTimer.reset(lengthInMinutes: scrum.lengthInMinutes, attendees: scrum.attendees)
            ///ScrumTimer calls this action when a speaker’s time expires.
            scrumTimer.speakerChangedAction = {
                ///Seeking to time .zero ensures the audio file always plays from the beginning.
                player.seek(to: .zero)
                ///Play the audio file
                player.play()
            }
            ///to start a new scrum timer after the timer resets
            scrumTimer.startScrum()
        }
        ///The timer stops each time an instance of MeetingView leaves the screen, indicating that a meeting has ended.
        .onDisappear {
            scrumTimer.stopScrum()
            /// The onDisappear(perform: ) closure updates the history without user interaction.
            let newHistory = History(attendees: scrum.attendees, lengthInMinutes: scrum.timer.secondsElapsed / 60)
            scrum.history.insert(newHistory, at: 0)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MeetingView_Previews: PreviewProvider {
    static var previews: some View {
        MeetingView(scrum: .constant(DailyScrum.sampleData[0]))
    }
}
