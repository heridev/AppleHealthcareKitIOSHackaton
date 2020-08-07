//
//  CareKitTabBarController.swift
//  GeanoCareKitHackaton
//
//  Created by heriberto perez on 8/7/20.
//  Copyright © 2020 heriberto perez. All rights reserved.
//

import UIKit
import CareKit

class CareKitTabBarController: UITabBarController {

    override func viewDidLoad() {
        
        super.viewDidLoad()

        let symptomTrackerVC = SymptomTrackerViewController(storeManager: CareStoreReferenceManager.shared.synchronizedStoreManager)
        
         let firstNavController = UINavigationController(rootViewController: symptomTrackerVC)
         firstNavController.tabBarItem.image = UIImage(named: "home_selected")
         firstNavController.tabBarItem.tag = 0
        
        let careViewControllerVC = CareViewController(storeManager: CareStoreReferenceManager.shared.synchronizedStoreManager)
         let secondNavController = UINavigationController(rootViewController: careViewControllerVC)
         secondNavController.title = "Another Tracking"
         secondNavController.tabBarItem.image = UIImage(named: "home_selected")
        
        let contactsViewControllerVC = OCKContactsListViewController(storeManager: CareStoreReferenceManager.shared.synchronizedStoreManager)
         let thirdNavController = UINavigationController(rootViewController: contactsViewControllerVC)
         thirdNavController.title = "Contacts"
         thirdNavController.tabBarItem.image = UIImage(named: "home_selected")

         viewControllers = [firstNavController, secondNavController, thirdNavController]

         tabBar.isTranslucent = false

         let topBorder = CALayer()
         topBorder.frame = CGRect(x: 0, y: 0, width: 1000, height: 0.5)
         topBorder.backgroundColor = UIColor.lightGray.cgColor

         tabBar.layer.addSublayer(topBorder)
         tabBar.clipsToBounds = true
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
