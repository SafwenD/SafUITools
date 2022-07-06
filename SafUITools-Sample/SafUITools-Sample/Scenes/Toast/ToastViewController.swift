//
//  ToastViewController.swift
//  SafUITools-Sample
//
//  Created by Safwen DEBBICHI on 27/12/2019.
//  Copyright © 2019 Safwen DEBBICHI. All rights reserved.
//

import UIKit
import SideMenuSwift
import SafUITools

class ToastViewController: UIViewController {
    
    let text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
    
    @IBAction func didChoseDirection(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            direction = .fromBottom
            break
        case 1:
            direction = .fromTop
           break
        default:
            break
        }
    }
    var direction: ToastSlidingDirection = .fromBottom {
        didSet {
            self.view.tinyToast(withText: text, animationDirection: direction, disappearAfter: 1.0)
        }
    }
    @IBAction func hideToast(_ sender: Any) {
        self.view.removeTinyToast()
    }
    
    @IBAction func fromBottomTapped(_ sender: Any) {
        self.view.tinyToast(withText: text, animationDirection: direction, disappearAfter: 1.0)
    }
    @IBAction func menuButtonTapped(_ sender: UIBarButtonItem) {
        sideMenuController?.revealMenu()
    }
}
