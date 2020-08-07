//
//  careStore.swift
//  GeanoCareKitHackaton
//
//  Created by heriberto perez on 8/6/20.
//  Copyright © 2020 heriberto perez. All rights reserved.
//

import Foundation
import CareKit

// Singleton wrapper to hold a reference to OCKSynchronizedStoreManager and task identifiers
final class CareStoreReferenceManager {
    
    enum TaskIdentifiers: String, CaseIterable {
        case coughingEpisodes
    }
    
    static let shared = CareStoreReferenceManager()
    
    // Manages synchronization of a CoreData store
    lazy var synchronizedStoreManager: OCKSynchronizedStoreManager = {
        let store = OCKStore(name: "GeanoHealthCare")
        store.populateDailyTasks()
        let manager = OCKSynchronizedStoreManager(wrapping: store)
        return manager
    }()
    
    private init() {}
}
