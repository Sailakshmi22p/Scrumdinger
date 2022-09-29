//
//  History.swift
//  Scrumdinger
//
//  Created by Sai Lakshmi on 6/9/22.
//

import Foundation

///The History structure has properties for storing the essential details of a scrum session: the date and length of the meeting, and a list of attendees.
struct History: Identifiable, Codable {
    let id: UUID
    let date: Date
    var attendees: [DailyScrum.Attendee]
    var lengthInMinutes: Int
    
    init(id: UUID = UUID(), date: Date = Date(), attendees: [DailyScrum.Attendee], lengthInMinutes: Int = 5) {
        self.id = id
        self.date = date
        self.attendees = attendees
        self.lengthInMinutes = lengthInMinutes
    }
}
