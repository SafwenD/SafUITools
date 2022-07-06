//
//  WalkThrough.swift
//  SafUITools
//
//  Created by Safwen DEBBICHI on 26/12/2019.
//  Copyright © 2019 Safwen DEBBICHI. All rights reserved.
//

import UIKit

extension CAShapeLayer {
    func scaleUpCircleAnimated(toRadius radius: CGFloat, origin: CGPoint) {
        //animate cornerRadius and update model
        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = 0.7
        //super important must match
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.fromValue = self.path
        animation.isRemovedOnCompletion = false
        animation.toValue = UIBezierPath(roundedRect: CGRect(x: origin.x, y: origin.y, width: 2 * radius, height: 2 * radius), cornerRadius: radius).cgPath
        self.add(animation, forKey: nil)
        //update model important
        self.path = UIBezierPath(roundedRect: CGRect(x: origin.x, y: origin.x, width: 2 * radius, height: 2 * radius), cornerRadius: 100).cgPath
    }
}

public class WalkThrough {
    public static let shared = WalkThrough()
    
    // MARK: Prefs
    public var defaultHighlightPadding: CGFloat = 20.0
    public var defaultHighlightCirclesCount: Int = 3
    public var defaultInfoViewWidth: CGFloat = UIScreen.main.bounds.size.width * 0.8
    public var defaultInfoAnimationDuration: TimeInterval = 0.5
    
    // MARK: vars
    var canvas: UIView  = UIView(frame: UIScreen.main.bounds)
    var currentHighlightedView: UIView? {
        guard let first = viewsArray.first else { return nil }
        return first.hightlightedView
    }
    var currentInfoText: String? {
        guard let first = viewsArray.first else { return nil }
        return first.text
    }
    var currentCustomInfoView: UIView? {
        guard let first = viewsArray.first else { return nil }
        return first.customInfoView
    }
    var currentStyle: WalkThroughTipStyle? {
        guard let first = viewsArray.first else { return nil }
        return first.style
    }
    var keyWindow: UIWindow? {
        return UIApplication.shared.windows.filter{$0.isKeyWindow}.first
    }
    var infoViewPlaceHolder: UIView?
    var viewsArray: [WalkThroughTip] = []
    
    public var walkThroughDidFinishCallBack: (()->Void)?
    
    // MARK: Setup Methods
    /// Adds a tip to the tips array
    /// - Parameter tip: WalkThroughTip
    public func addTip(tip: WalkThroughTip) {
        viewsArray.append(tip)
    }
    
    /// Sets up the canvas view and adds it the keyWindow
    func setupCanvas() {
        // add subview
        keyWindow?.addSubview(canvas)
        // constraints
        if let superView = canvas.superview {
            canvas.translatesAutoresizingMaskIntoConstraints = false
            canvas.topAnchor.constraint(equalTo: superView.topAnchor, constant: 0).isActive = true
            canvas.leftAnchor.constraint(equalTo: superView.leftAnchor, constant: 0).isActive = true
            canvas.rightAnchor.constraint(equalTo: superView.rightAnchor, constant: 0).isActive = true
            canvas.bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: 0).isActive = true
        }
        // tap gesture
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        canvas.addGestureRecognizer(tap)
    }
    
    /// Starts the WalkThrough
    public func walkThrough() {
        setupCanvas()
        highlight()
    }
    
    // MARK: Core Grahics
    /// Calculates the path to highlight the UIView
    func calculatePathToHighlight() -> UIBezierPath? {
        guard let viewToHighlight = currentHighlightedView else { return nil }
        let circularStyleHightlight: Bool = currentStyle?.shouldUseCircularHighlight ?? true
        let bounds = viewToHighlight.bounds
        let viewCornerRadius: CGFloat? = viewToHighlight.layer.cornerRadius != 0 ? viewToHighlight.layer.cornerRadius : nil
        let biggerRect = CGRect(x: bounds.origin.x, y: bounds.origin.x, width: bounds.size.width + defaultHighlightPadding, height: bounds.size.height + defaultHighlightPadding)
        let radius = max(biggerRect.width, biggerRect.height) / 2
        let offsetPoint: CGPoint = viewToHighlight.convert(viewToHighlight.bounds, to: canvas).origin
        let origin = CGPoint(x: offsetPoint.x - radius + viewToHighlight.bounds.width/2 - defaultHighlightPadding/2, y: offsetPoint.y - radius + viewToHighlight.bounds.height/2 - defaultHighlightPadding/2)
        let path = UIBezierPath(roundedRect: circularStyleHightlight ? CGRect(origin: CGPoint(x: origin.x, y: origin.y), size: CGSize(width: 2*radius + defaultHighlightPadding, height: 2*radius + defaultHighlightPadding)) : biggerRect, cornerRadius: circularStyleHightlight ? radius : viewCornerRadius ?? 0)
        if !circularStyleHightlight{
            path.apply(CGAffineTransform(translationX: offsetPoint.x - defaultHighlightPadding/2, y: offsetPoint.y - defaultHighlightPadding/2))
        }
        return path
    }
    
    // MARK: Info View
    /// Inserts an info view inside the infoViewPlaceHolder
    /// - Parameter view: View to insert
    func showInfoView(embeddingView view: UIView) {
        guard let infoView = infoViewPlaceHolder else { return }
        infoView.alpha = 0
        // constraints
        canvas.addSubview(infoView)
        infoView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.centerYAnchor.constraint(equalTo: infoView.centerYAnchor).isActive = true
        view.centerXAnchor.constraint(equalTo: infoView.centerXAnchor).isActive = true
        view.widthAnchor.constraint(lessThanOrEqualTo: infoView.widthAnchor).isActive = true
        view.heightAnchor.constraint(lessThanOrEqualTo: infoView.heightAnchor).isActive = true
        // animate
        UIView.transition(with: infoView, duration: defaultInfoAnimationDuration, options: [.transitionCrossDissolve], animations: {
            infoView.alpha = 1
        }, completion: nil)
    }
    
    /// Sets up the info view and it's frame
    func setInfoView() {
        guard let viewToHighlight = currentHighlightedView else { return }
        canvas.translatesAutoresizingMaskIntoConstraints = false
        let screenBounds = UIScreen.main.bounds
        var infoViewHeight: CGFloat = .zero
        var origin: CGPoint = .zero
        if (viewToHighlight.frame.origin.y + 45) > (screenBounds.size.height/2){
            // info view can be in fist half
            infoViewHeight = (viewToHighlight.frame.origin.y / 3) * 0.8
            origin = CGPoint(x: screenBounds.width/2 - defaultInfoViewWidth/2, y: infoViewHeight)
        } else {
            // info view can be in second half
            infoViewHeight = ((screenBounds.size.height - viewToHighlight.frame.origin.y) / 3)
            origin = CGPoint(x: screenBounds.width/2 - defaultInfoViewWidth/2, y: (viewToHighlight.frame.origin.y + viewToHighlight.frame.height + infoViewHeight))
        }
        infoViewPlaceHolder = UIView(frame: CGRect(x: origin.x, y: origin.y, width: defaultInfoViewWidth, height: infoViewHeight))
        infoViewPlaceHolder?.backgroundColor = .clear
        infoViewPlaceHolder?.clipsToBounds = true
    }
    
    // MARK: Highlight
    /// Highlights the given view and creates circle layers around it
    func highlight() {
        guard let viewToHighlight = currentHighlightedView else {
            canvas.removeFromSuperview()
            if let finishCallBack = walkThroughDidFinishCallBack {
                finishCallBack()
                walkThroughDidFinishCallBack = nil
            }
            return
        }
        // set canvas style
        canvas.backgroundColor = currentStyle?.backgroundColor
        
        // draw circles
        let overralPath = UIBezierPath(rect: UIScreen.main.bounds)
        createCircles()
        
        // calculate path to highlight
        guard let path = calculatePathToHighlight() else { return }
        overralPath.append(path)
        
        // mask the view
        let maskLayer = CAShapeLayer()
        maskLayer.frame = viewToHighlight.bounds
        maskLayer.fillRule = .evenOdd
        maskLayer.path = overralPath.cgPath
        canvas.layer.mask = maskLayer
        
        // Info View Setup
        if let customInfoView = currentCustomInfoView {
            // show custom info view
            customInfoView.alpha = 0
            canvas.addSubview(customInfoView)
            UIView.transition(with: customInfoView, duration: defaultInfoAnimationDuration, options: [.transitionCrossDissolve], animations: {
                customInfoView.alpha = 1
            }, completion: nil)
        } else if let textInfo = currentInfoText {
            setInfoView()
            let label = PaddingLabel(withInsets: 8, 8, 8, 8)
            label.backgroundColor = currentStyle?.infoLabelBackgroundColor
            label.layer.cornerRadius = 8
            label.clipsToBounds = true
            label.textColor = currentStyle?.infoLabelTextColor
            label.text = textInfo
            label.font = UIFont(name: "Robotto", size: 16)
            label.textAlignment = .center
            label.adjustsFontSizeToFitWidth = true
            label.numberOfLines = 0
            showInfoView(embeddingView: label)
        }
    }
    
    /// removes the highlighting layers
    func unHighlight() {
        canvas.layer.mask = nil
        viewsArray.removeFirst()
        if let infoView = infoViewPlaceHolder {
            infoView.removeFromSuperview()
            infoViewPlaceHolder = nil
        }
        if let subLayers = canvas.layer.sublayers {
            for subLayer in subLayers {
                subLayer.removeFromSuperlayer()
            }
        }
    }
    // MARK: Circles
    /// Creates the highlighting circles layers
    func createCircles() {
        guard let highlightedView = currentHighlightedView else { return }
        let screenBound = UIScreen.main.bounds
        let maxRadius = screenBound.height * 0.4
        let offset = maxRadius/CGFloat(defaultHighlightCirclesCount)
        var radius = offset
        for _ in 0..<defaultHighlightCirclesCount {
            let circleLayer = CAShapeLayer()
            let offsetPoint: CGPoint = highlightedView.convert(highlightedView.bounds, to: canvas).origin
            let origin = CGPoint(x: offsetPoint.x - radius + highlightedView.bounds.width/2, y: offsetPoint.y - radius + highlightedView.bounds.height/2)
            let path = UIBezierPath(roundedRect: CGRect(x: origin.x + radius, y: origin.y + radius, width: 0, height: 0), cornerRadius: radius)
            circleLayer.path = path.cgPath
            circleLayer.fillColor = currentStyle?.circlesColor.cgColor
            circleLayer.opacity = 0.2
            canvas.layer.addSublayer(circleLayer)
            circleLayer.scaleUpCircleAnimated(toRadius: radius, origin: origin)
            radius = radius * 2
        }
    }
    
    // MARK: Tap Gesture
    /// Handles the tap on the hihglighted view
    /// - Parameter tapGesture: tapGesture
    @objc func handleTap(_ tapGesture: UITapGestureRecognizer) {
        guard let highlighted = currentHighlightedView else { return }
        let touchPosition = tapGesture.location(in: highlighted)
        if touchPosition.x >= 0 && touchPosition.x <= highlighted.frame.size.width && touchPosition.y >= 0 && touchPosition.y <= highlighted.frame.size.height {
            unHighlight()
            highlight()
        }
    }
}
