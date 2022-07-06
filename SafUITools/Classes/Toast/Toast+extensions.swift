//
//  Toast+extensions.swift
//  SafUITools
//
//  Created by Safwen DEBBICHI on 30/12/2019.
//

import UIKit
@available (iOS 11.0, *)
public extension UIView {
    func tinyToast(withText text: String, font: UIFont = UIFont.systemFont(ofSize: 16), backgroundColor: UIColor = UIColor.black.withAlphaComponent(0.4), textColor: UIColor = .white, animationDirection: ToastSlidingDirection, disappearAfter: TimeInterval? = nil) {
        self.removeTinyToast()
        let toastView = TinyToast(withText: text, font: font, backgroundColor: backgroundColor, textColor: textColor, animationDirection: animationDirection, disappearAfter: disappearAfter)
        toastView.tag = TinyToast.kTinyToastTag
        self.addSubview(toastView)
        toastView.translatesAutoresizingMaskIntoConstraints = false
        toastView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        toastView.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, multiplier: 0.9).isActive = true
    }
    func removeTinyToast() {
        self.toastView?.removeAnimated()
    }
    var toastView: TinyToast? {
        return self.subviews.first{$0.tag == TinyToast.kTinyToastTag} as? TinyToast
    }
}
