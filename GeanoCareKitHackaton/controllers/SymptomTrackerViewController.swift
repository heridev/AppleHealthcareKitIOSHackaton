//
//  SymptomTrackerViewController.swift
//  GeanoCareKitHackaton
//
//  Created by heriberto perez on 8/6/20.
//  Copyright © 2020 heriberto perez. All rights reserved.
//

import UIKit

import UIKit
import CareKit

final class SymptomTrackerViewController: OCKDailyPageViewController {
    
    init(storeManager: OCKSynchronizedStoreManager = CareStoreReferenceManager.shared.synchronizedStoreManager) {
        print("our symptomtracker is initialized..")
        super.init(storeManager: storeManager)
    }
    
//    required init?(storeManager: OCKSynchronizedStoreManager = CareStoreReferenceManager.shared.synchronizedStoreManager) {
//            super.init(storeManager: storeManager)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Tracking"
    }
    
    override func dailyPageViewController(_ dailyPageViewController: OCKDailyPageViewController,
                                          prepare listViewController: OCKListViewController, for date: Date) {
        
        let identifiers = CareStoreReferenceManager.TaskIdentifiers.allCases.map { $0.rawValue }
        var query = OCKTaskQuery(for: date)
        query.ids = identifiers
        query.excludesTasksWithNoEvents = true
        
        storeManager.store.fetchAnyTasks(query: query, callbackQueue: .main) { result in
            guard let tasks = try? result.get() else { return }
            
            tasks.forEach { task in
                switch task.id {
                case CareStoreReferenceManager.TaskIdentifiers.coughingEpisodes.rawValue:
                    let coughingCard = OCKButtonLogTaskViewController(task: task,
                                                                      eventQuery: .init(for: date),
                                                                      storeManager: self.storeManager)
                    listViewController.appendViewController(coughingCard, animated: false)
                default: return
                }
            }
        }
    }
}
