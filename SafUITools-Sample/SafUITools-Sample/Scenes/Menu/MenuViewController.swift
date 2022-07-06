//
//  MenuViewController.swift
//  SafUITools-Sample
//
//  Created by Safwen DEBBICHI on 22/12/2019.
//  Copyright © 2019 Safwen DEBBICHI. All rights reserved.
//

import UIKit
import SideMenuSwift

class MenuCell: UITableViewCell {
    @IBOutlet weak var pageTitle: UILabel?
}

let kMenuPages = ["ShadowLoader", "WalkThrough", "Toast"]

class MenuViewController: UIViewController {
    @IBOutlet weak var selectionMenuTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView! {
        didSet{
            tableView.dataSource = self
            tableView.delegate = self
            tableView.separatorStyle = .none
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenuController?.delegate = self
        
        sideMenuController?.cache(viewControllerGenerator: {
            UIStoryboard(name: "LoadingMask", bundle: nil).instantiateViewController(withIdentifier: "LoadingMaskTableView")
        }, with: "1")
        sideMenuController?.cache(viewControllerGenerator: {
            UIStoryboard(name: "WalkThrough", bundle: nil).instantiateViewController(withIdentifier: "WalkThrough")
        }, with: "2")
        sideMenuController?.cache(viewControllerGenerator: {
            UIStoryboard(name: "Toast", bundle: nil).instantiateViewController(withIdentifier: "Toast")
        }, with: "3")
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        let sidemenuBasicConfiguration = SideMenuController.preferences.basic
        let showPlaceTableOnLeft = (sidemenuBasicConfiguration.position == .under) != (sidemenuBasicConfiguration.direction == .right)
        selectionMenuTrailingConstraint.constant = showPlaceTableOnLeft ? SideMenuController.preferences.basic.menuWidth - size.width : 0
        view.layoutIfNeeded()
    }
}

extension MenuViewController: SideMenuControllerDelegate {
    func sideMenuController(_ sideMenuController: SideMenuController,
                            animationControllerFrom fromVC: UIViewController,
                            to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BasicTransitionAnimator(options: .transitionFlipFromLeft, duration: 0.6)
    }

    func sideMenuController(_ sideMenuController: SideMenuController, willShow viewController: UIViewController, animated: Bool) {
    }

    func sideMenuController(_ sideMenuController: SideMenuController, didShow viewController: UIViewController, animated: Bool) {
    }

    func sideMenuControllerWillHideMenu(_ sideMenuController: SideMenuController) {
    }

    func sideMenuControllerDidHideMenu(_ sideMenuController: SideMenuController) {
    }

    func sideMenuControllerWillRevealMenu(_ sideMenuController: SideMenuController) {
    }

    func sideMenuControllerDidRevealMenu(_ sideMenuController: SideMenuController) {
    }
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kMenuPages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell") as? MenuCell else { return UITableViewCell() }
        cell.pageTitle?.text = kMenuPages[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row

        sideMenuController?.setContentViewController(with: "\(row+1)", animated: false)
        sideMenuController?.hideMenu()

        if let identifier = sideMenuController?.currentCacheIdentifier() {
            print("[Example] View Controller Cache Identifier: \(identifier)")
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
