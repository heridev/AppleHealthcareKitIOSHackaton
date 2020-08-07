//
//  CareViewController.swift
//  GeanoCareKitHackaton
//
//  Created by heriberto perez on 8/7/20.
//  Copyright © 2020 heriberto perez. All rights reserved.
//

import Foundation
import UIKit
import CareKit

class CareViewController: OCKDailyPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(title: "Care Team", style: .plain, target: self,
                            action: #selector(presentContactsListViewController))
    }

    @objc private func presentContactsListViewController() {
        let viewController = OCKContactsListViewController(storeManager: storeManager)
        viewController.title = "Care Team"
        viewController.isModalInPresentation = true
        viewController.navigationItem.rightBarButtonItem =
            UIBarButtonItem(title: "Done", style: .plain, target: self,
                            action: #selector(dismissContactsListViewController))

        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true, completion: nil)
    }

    @objc private func dismissContactsListViewController() {
        dismiss(animated: true, completion: nil)
    }

    // This will be called each time the selected date changes.
    // Use this as an opportunity to rebuild the content shown to the user.

    override func dailyPageViewController(_ dailyPageViewController: OCKDailyPageViewController,
                                          prepare listViewController: OCKListViewController, for date: Date) {

        let identifiers = ["doxylamine", "nausea", "kegels"]
        var query = OCKTaskQuery(for: date)
        query.ids = identifiers
        query.excludesTasksWithNoEvents = true

        storeManager.store.fetchAnyTasks(query: query, callbackQueue: .main) { result in
            switch result {
            case .failure(let error): print("Error: \(error)")
            case .success(let tasks):

                // Add a non-CareKit view into the list
                let tipTitle = "Benefits of exercising"
                let tipText = "Learn how activity can promote a healthy pregnancy."

                // Only show the tip view on the current date
                if Calendar.current.isDate(date, inSameDayAs: Date()) {
                    let tipView = TipView()
                    tipView.headerView.titleLabel.text = tipTitle
                    tipView.headerView.detailLabel.text = tipText
                    tipView.imageView.image = UIImage(named: "exercise.jpg")
                    listViewController.appendView(tipView, animated: false)
                }

                // Since the kegel task is only sheduled every other day, there will be cases
                // where it is not contained in the tasks array returned from the query.
                if let kegelsTask = tasks.first(where: { $0.id == "kegels" }) {
                    let kegelsCard = OCKSimpleTaskViewController(task: kegelsTask, eventQuery: .init(for: date),
                                                                 storeManager: self.storeManager)
                    listViewController.appendViewController(kegelsCard, animated: false)
                }

                // Create a card for the doxylamine task if there are events for it on this day.
                if let doxylamineTask = tasks.first(where: { $0.id == "doxylamine" }) {
                    let doxylamineCard = OCKChecklistTaskViewController(task: doxylamineTask, eventQuery: .init(for: date),
                                                                        storeManager: self.storeManager)
                    listViewController.appendViewController(doxylamineCard, animated: false)
                }

                // Create a card for the nausea task if there are events for it on this day.
                // Its OCKSchedule was defined to have daily events, so this task should be
                // found in `tasks` every day after the task start date.
                if let nauseaTask = tasks.first(where: { $0.id == "nausea" }) {

                    // dynamic gradient colors
                    let nauseaGradientStart = UIColor { traitCollection -> UIColor in
                        return traitCollection.userInterfaceStyle == .light ? #colorLiteral(red: 0.9960784314, green: 0.3725490196, blue: 0.368627451, alpha: 1) : #colorLiteral(red: 0.8627432641, green: 0.2630574384, blue: 0.2592858295, alpha: 1)
                    }
                    let nauseaGradientEnd = UIColor { traitCollection -> UIColor in
                        return traitCollection.userInterfaceStyle == .light ? #colorLiteral(red: 0.9960784314, green: 0.4732026144, blue: 0.368627451, alpha: 1) : #colorLiteral(red: 0.8627432641, green: 0.3598620686, blue: 0.2592858295, alpha: 1)
                    }

                    // Create a plot comparing nausea to medication adherence.
                    let nauseaDataSeries = OCKDataSeriesConfiguration(
                        taskID: "nausea",
                        legendTitle: "Nausea",
                        gradientStartColor: nauseaGradientStart,
                        gradientEndColor: nauseaGradientEnd,
                        markerSize: 10,
                        eventAggregator: OCKEventAggregator.countOutcomeValues)

                    let doxylamineDataSeries = OCKDataSeriesConfiguration(
                        taskID: "doxylamine",
                        legendTitle: "Doxylamine",
                        gradientStartColor: .systemGray2,
                        gradientEndColor: .systemGray,
                        markerSize: 10,
                        eventAggregator: OCKEventAggregator.countOutcomeValues)

                    let insightsCard = OCKCartesianChartViewController(plotType: .bar, selectedDate: date,
                                                                       configurations: [nauseaDataSeries, doxylamineDataSeries],
                                                                       storeManager: self.storeManager)
                    insightsCard.chartView.headerView.titleLabel.text = "Nausea & Doxylamine Intake"
                    insightsCard.chartView.headerView.detailLabel.text = "This Week"
                    insightsCard.chartView.headerView.accessibilityLabel = "Nausea & Doxylamine Intake, This Week"
                    listViewController.appendViewController(insightsCard, animated: false)

                    // Also create a card that displays a single event.
                    // The event query passed into the initializer specifies that only
                    // today's log entries should be displayed by this log task view controller.
                    let nauseaCard = OCKButtonLogTaskViewController(task: nauseaTask, eventQuery: .init(for: date),
                                                                    storeManager: self.storeManager)
                    listViewController.appendViewController(nauseaCard, animated: false)
                }
            }
        }
    }
}
