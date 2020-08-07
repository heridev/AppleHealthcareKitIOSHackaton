//
//  MainViewController.swift
//  GeanoCareKitHackaton
//
//  Created by heriberto perez on 8/6/20.
//  Copyright © 2020 heriberto perez. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func LoginButtonTapped(_ sender: Any) {
        print("que esta pasando")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let careKitTabBarController = storyboard.instantiateViewController(withIdentifier: "CareKitTabBarControllerStoryID")
        
        view.window?.rootViewController = careKitTabBarController
        view.window?.makeKeyAndVisible()
                
        
//        rendering the tabbarcontroller
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//
//        let tabBarController = storyboard.instantiateViewController(withIdentifier: "UITabBarControllerID")
//
//        view.window?.rootViewController = tabBarController
//        view.window?.makeKeyAndVisible()
        
//        let symptomTrackerVC = SymptomTrackerViewController(storeManager: CareStoreReferenceManager.shared.synchronizedStoreManager)
//        let careViewController = UINavigationController(rootViewController: symptomTrackerVC)
//
//
//        view.window?.rootViewController = careViewController
//        view.window?.makeKeyAndVisible()
        
    }
    
}
