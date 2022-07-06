//
//  DashboardViewController.swift
//  SafUITools-Sample
//
//  Created by Safwen DEBBICHI on 22/12/2019.
//  Copyright © 2019 Safwen DEBBICHI. All rights reserved.
//

import UIKit
import SideMenuSwift
import SafUITools

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var welcomeTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        welcomeTitle.text = "SafUITools: v\(SafUIToolsVersionNumber)"
    }
    
    @IBAction func menuButtonPressed(_ sender: UIBarButtonItem) {
        sideMenuController?.revealMenu()
    }
}
