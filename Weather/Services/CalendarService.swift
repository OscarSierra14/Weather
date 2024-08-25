//
//  CalendarService.swift
//  Weather
//
//  Created by Oscar Sierra Zuñiga on 22/08/24.
//

import EventKit

class CalendarService {
    let eventStore = EKEventStore()

    func addWeatherReminder(for location: Location) {
        eventStore.requestAccess(to: .event) { granted, error in
            if granted {
                let event = EKEvent(eventStore: self.eventStore)
                event.title = "Check Weather for \(location.cityName)"
                event.startDate = Date()
                event.endDate = event.startDate.addingTimeInterval(3600)
                event.calendar = self.eventStore.defaultCalendarForNewEvents

                do {
                    try self.eventStore.save(event, span: .thisEvent)
                } catch {
                    print("Failed to save event with error: \(error)")
                }
            }
        }
    }
}
