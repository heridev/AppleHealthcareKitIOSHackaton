//
//  OCKDailyStore+PopulateCarePlan.swift
//  GeanoCareKitHackaton
//
//  Created by heriberto perez on 8/6/20.
//  Copyright © 2020 heriberto perez. All rights reserved.
//

import Foundation
import Contacts
import CareKit

extension OCKStore {

    // Adds tasks and contacts into the store
    func populateDailyTasks() {

        let thisMorning = Calendar.current.startOfDay(for: Date())
        guard let beforeBreakfast = Calendar.current.date(byAdding: .hour, value: 8, to: thisMorning) else {
            return assertionFailure("Could not create time 8AM this morning")
        }

        let coughingSchedule = OCKSchedule(composing: [
            OCKScheduleElement(start: beforeBreakfast,
                               end: nil,
                               interval: DateComponents(day: 1),
                               text: "Anytime throughout the day",
                               targetValues: [],
                               duration: .allDay)
        ])

        var coughingTask = OCKTask(id: CareStoreReferenceManager.TaskIdentifiers.coughingEpisodes.rawValue,
                                   title: "Track Anxiety",
                                   carePlanID: nil, schedule: coughingSchedule)
        
        coughingTask.instructions = "If you experience anxiety, please log it here."
        coughingTask.impactsAdherence = false
        addTask(coughingTask)
        populateContacts()
    }
    
    func populateContacts() {
        var contact1 = OCKContact(id: "jane", givenName: "Jane",
                                  familyName: "Daniels", carePlanID: nil)
        contact1.asset = "JaneDaniels"
        contact1.title = "Family Practice Doctor"
        contact1.role = "Dr. Daniels is a family practice doctor with 8 years of experience."
        contact1.emailAddresses = [OCKLabeledValue(label: CNLabelEmailiCloud, value: "janedaniels@icloud.com")]
        contact1.phoneNumbers = [OCKLabeledValue(label: CNLabelWork, value: "(324) 555-7415")]
        contact1.messagingNumbers = [OCKLabeledValue(label: CNLabelWork, value: "(324) 555-7415")]

        contact1.address = {
            let address = OCKPostalAddress()
            address.street = "2598 Reposa Way"
            address.city = "San Francisco"
            address.state = "CA"
            address.postalCode = "94127"
            return address
        }()

        var contact2 = OCKContact(id: "matthew", givenName: "Matthew",
                                  familyName: "Reiff", carePlanID: nil)
        contact2.asset = "MatthewReiff"
        contact2.title = "OBGYN"
        contact2.role = "Dr. Reiff is an OBGYN with 13 years of experience."
        contact2.phoneNumbers = [OCKLabeledValue(label: CNLabelWork, value: "(324) 555-7415")]
        contact2.messagingNumbers = [OCKLabeledValue(label: CNLabelWork, value: "(324) 555-7415")]
        contact2.address = {
            let address = OCKPostalAddress()
            address.street = "396 El Verano Way"
            address.city = "San Francisco"
            address.state = "CA"
            address.postalCode = "94127"
            return address
        }()

        addContacts([contact1, contact2])
    }
}
