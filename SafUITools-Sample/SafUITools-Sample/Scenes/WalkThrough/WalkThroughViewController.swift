//
//  WalkThroughViewController.swift
//  SafUITools-Sample
//
//  Created by Safwen DEBBICHI on 23/12/2019.
//  Copyright © 2019 Safwen DEBBICHI. All rights reserved.
//

import UIKit
import SideMenuSwift
import SafUITools

class WalkThroughViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    let didFinishTutorial: ()->() = { ()->() in
        print("finished walkthrough !")
    }
    
    func setupTutorial() {
        let style1 = WalkThroughTipStyle(backgroundColor: UIColor(red: 4/256, green: 128/256, blue: 222/256, alpha: 1.0),
                                        circlesColor: UIColor(red: 4/256, green: 200/256, blue: 222/256, alpha: 1.0),
                                        infoLabelTextColor: .black,
                                        infoLabelBackgroundColor: .white)

        let style2 = WalkThroughTipStyle(backgroundColor: UIColor(red: 222/256, green: 4/256, blue: 52/256, alpha: 1.0),
                                         infoLabelTextColor: .black,
                                         infoLabelBackgroundColor: .white)
        let style3 = WalkThroughTipStyle(backgroundColor: UIColor(red: 17/256, green: 194/256, blue: 103/256, alpha: 1.0),
                                         infoLabelTextColor: .black,
                                         infoLabelBackgroundColor: .white)

        let style4 = WalkThroughTipStyle(backgroundColor: UIColor(red: 232/256, green: 232/256, blue: 20/256, alpha: 1.0),
                                         infoLabelTextColor: .black,
                                         infoLabelBackgroundColor: .white)
        
        let tip1 = WalkThroughTip(hightlightedView: menuButton.value(forKey: "view") as? UIView, customInfoView: nil, text: "This is the menu button, it's a beautiful button made by me... tap it to show the menu on the left please...", style: style1)

        let tip2 = WalkThroughTip(hightlightedView: label, customInfoView: nil, text: "This is the login label, it's a beautiful label made by me...", style: style2)

        let tip3 = WalkThroughTip(hightlightedView: textField, customInfoView: nil, text: "This is the login textField, it's a really nice login textField... tap your code in before you login", style: style3)

        let tip4 = WalkThroughTip(hightlightedView: button, customInfoView: nil, text: "This is the login button, it's a beautiful button made by me... tap it to login", style: style4)
        
        WalkThrough.shared.addTip(tip: tip1)
        WalkThrough.shared.addTip(tip: tip2)
        WalkThrough.shared.addTip(tip: tip3)
        WalkThrough.shared.addTip(tip: tip4)
        
        WalkThrough.shared.walkThroughDidFinishCallBack = didFinishTutorial
    }
    
    @IBAction func startWalkThrough(_ sender: UIButton) {
        setupTutorial()
        WalkThrough.shared.walkThrough()
    }
    
    @IBAction func didTapOnMenu(_ sender: Any) {
        sideMenuController?.revealMenu()
    }
}

