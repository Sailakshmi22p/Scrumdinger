//
//  MeetingFooterView.swift
//  Scrumdinger
//
//  Created by Sai Lakshmi on 5/27/22.
//

import SwiftUI

struct MeetingFooterView: View {
    let speakers: [ScrumTimer.Speaker]
    //You’ll use skipAction to allow users to skip to the next speaker.
    var skipAction: () -> Void
    
    //The first speaker not marked as completed becomes the active speaker.
    private var speakerNumber: Int? {
        guard let index = speakers.firstIndex( where: { !$0.isCompleted }) else { return nil }
        return index + 1
    }
   
    //Checks whether the active speaker is the last speaker.
    //This property is true if the isCompleted property of each speaker except the last speaker is true.
    ///TIP: You can get the same result with reduce(_:_:) by returning speakers.dropLast().reduce(true) { $0 && $1.isCompleted }.
    private var isLastSpeaker: Bool {
        return speakers.dropLast().allSatisfy { $0.isCompleted }
    }
    
    //Add a private computed property that returns information about the active speaker and pass it to the Text view.
    private var speakerText: String {
        guard let speakerNumber = speakerNumber else { return "No more speakers"}
        return "Speaker \(speakerNumber) of \(speakers.count)"
    }
    
    var body: some View {
        VStack {
            HStack {
                if isLastSpeaker {
                    Text("Last Speaker")
                } else {
                    Text(speakerText)
                    Spacer()
                    Button(action: skipAction) {
                        Image(systemName: "forward.fill")
                    }
                    //VoiceOver reads the label, followed by the inherent accessibility trait: “Next speaker. Button.”
                    .accessibilityLabel("Next speaker")
                }
            }
        }
        .padding([.bottom, .horizontal])
    }
}

struct MeetingFooterView_Previews: PreviewProvider {
    static var previews: some View {
        MeetingFooterView(speakers: DailyScrum.sampleData[0].attendees.speakers, skipAction: {})
            .previewLayout(.sizeThatFits)
    }
}
