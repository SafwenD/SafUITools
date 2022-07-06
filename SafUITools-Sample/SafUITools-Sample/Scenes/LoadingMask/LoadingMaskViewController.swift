//
//  ViewController.swift
//  SafUITools-Sample
//
//  Created by Safwen DEBBICHI on 09/12/2019.
//  Copyright © 2019 Safwen DEBBICHI. All rights reserved.
//

import UIKit
import SafUITools


class LoadingExampleCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: UIImageView?
    @IBOutlet weak var messageLabel: UILabel?
    @IBOutlet weak var shareButton: UIButton?
}

class LoadingMaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? LoadingExampleCell else {
            return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @IBAction func startLoading(_ sender: Any) {
        self.startLoadingTableView()
    }
    
    @IBAction func stopLoading(_ sender: Any) {
        self.stopLoadingTableView()
    }
    
    func startLoadingTableView() {
        LoadingMask.shared.applyLoader(onView: self.tableview, tableViewCellIdenitifer: cellIdentifier, animationStyle: animationStyle)
    }
    
    func stopLoadingTableView() {
        LoadingMask.shared.removeLoader(fromView: self.tableview)
    }
    
    let cellIdentifier = "textCellExampleIdentifier"

    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.rowHeight = UITableView.automaticDimension
        // Override the defaultTableViewCellCount
        LoadingMask.shared.defaultTableViewCellCount = 3
    }
    
    @IBAction func menuButtonPressed(_ sender: UIBarButtonItem) {
        sideMenuController?.revealMenu()
    }
    
    var animationStyle: ShadowLoaderAnimationStyle = .none
    
    @IBAction func animationStyleDidChange(_ sender: UISegmentedControl) {
        let option = sender.selectedSegmentIndex
        switch option {
        case 0:
            animationStyle = .none
        case 1:
            animationStyle = .fade
        default:
            animationStyle = .wave
        }
        if LoadingMask.shared.isMasking(view: self.tableview) {
            self.startLoadingTableView()
        }
    }
}

