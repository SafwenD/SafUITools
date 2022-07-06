//
//  WavingLoader.swift
//  SafUITools
//
//  Created by Safwen DEBBICHI on 13/12/2019.
//  Copyright © 2019 Safwen DEBBICHI. All rights reserved.
//

import UIKit

public enum ShadowLoaderAnimationStyle {
    case wave, fade, none
}

public class LoadingMask {
    
    let defaultCornerRadius: CGFloat = 4
    let defaultMinMaskHeight: CGFloat = 20
    let defaultTextLinesSpacing: CGFloat = 8
    let defaultMaxTextLines: Int = 3
    public var defaultTableViewCellCount: Int = 3
    let kMaskLayerName = "LoadingMaskLayerName"
    let defaultAnimationDuration = 0.3
    
    var cellIdentifier: String?
    var animationStyle: ShadowLoaderAnimationStyle = .wave
    
    public static let shared = LoadingMask()
    
    /// Returns a UIBezierPath mask for UILabel and UITextView
    /// Handles multi line text
    /// - Parameter view: UILabel or UITextView
    private func calculateMask(forText view: UIView) -> UIBezierPath{
        let viewCornerRadius: CGFloat? = view.layer.cornerRadius != 0 ? view.layer.cornerRadius: nil
        let height = view.bounds.size.height
        let width = view.bounds.size.width
        
        let spacedLineHeight = defaultMinMaskHeight + defaultTextLinesSpacing
        let layerLinesCount: Int = Int(height/spacedLineHeight) > defaultMaxTextLines ? defaultMaxTextLines : Int(height/spacedLineHeight)
        let basicPath = UIBezierPath()
        if layerLinesCount == 0 {
            let relativePath = UIBezierPath(roundedRect: CGRect(x: view.bounds.origin.x, y: view.bounds.origin.y, width: width, height: height), cornerRadius: viewCornerRadius ?? defaultCornerRadius)
            basicPath.append(relativePath)
        } else {
            for i in 0..<layerLinesCount {
                let relativeOrigin = CGPoint(x: view.bounds.origin.x, y: view.bounds.origin.y + CGFloat(i) * spacedLineHeight)
                let relativeWidth = width/CGFloat(i+1)
                let relativePath = UIBezierPath(roundedRect: CGRect(x: relativeOrigin.x, y: relativeOrigin.y, width: relativeWidth, height: defaultMinMaskHeight), cornerRadius: viewCornerRadius ?? defaultCornerRadius)
                basicPath.append(relativePath)
            }
        }
        return basicPath
    }
    
    /// Returns a UIBezierPath mask for a UIView and it's subviews
    /// - Parameter view: UIView
    private func calculateMask(forView view: UIView) -> UIBezierPath{
        let basicPath = UIBezierPath()
        guard view.bounds.height >= defaultMinMaskHeight else {
            return basicPath
        }
        let subviews = view.subviews
        if subviews.isEmpty || view is UIButton {
            // calculate mask for the whole view
            let viewCornerRadius: CGFloat? = view.layer.cornerRadius != 0 ? view.layer.cornerRadius: nil
            let path = UIBezierPath(roundedRect: view.bounds, cornerRadius: viewCornerRadius ?? defaultCornerRadius)
            basicPath.append(path)
        } else {
            // calculate masks for subviews
            for subView in subviews {
                let offsetPoint: CGPoint = subView.convert(subView.bounds, to: view).origin
                subView.layoutIfNeeded()
                if let path = getMaskablePath(view: subView) {
                    // Transform the origin of the path relativly to the superview
                    path.apply(CGAffineTransform(translationX: offsetPoint.x, y: offsetPoint.y))
                    basicPath.append(path)
                }
            }
        }
        return basicPath
    }
    
    /// Creates a Bezier Path for a UITableView
    /// - Parameter tableView: UITableView
    private func calculateMask(forTableView tableView: UIView) -> UIBezierPath {
        let basicPath = UIBezierPath()
        guard let identifier = cellIdentifier, let cell = (tableView as! UITableView).dequeueReusableCell(withIdentifier: identifier) else {
            return basicPath
        }
        let path = calculateMask(forView: cell)
        basicPath.append(path)
        for _ in 1..<defaultTableViewCellCount {
            path.apply(CGAffineTransform(translationX: cell.frame.origin.x, y: cell.frame.size.height))
            basicPath.append(path)
        }
        
        return basicPath
    }
    
    /// Returns the Bezier Path depending on the view Type
    /// - Parameter view: UIView
    private func getMaskablePath(view: UIView) -> UIBezierPath? {
        if view is UILabel || view is UITextView {
            return calculateMask(forText: view)
        } else if view is UITableView {
            return calculateMask(forTableView: view)
        } else {
            return calculateMask(forView: view)
        }
    }
    
    /// Fills the MaskablePath for a view
    /// - Parameter view: UIView
    private func fillPaths(view: UIView) {
        guard let maskablePath = self.getMaskablePath(view: view) else { return }

        // Gradient Layer
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.locations = [0, 0.2, 0.4, 0.7, 1]
        gradientLayer.colors = [UIColor(red: 160/256, green: 160/256, blue: 160/256, alpha: 1).cgColor,
                                UIColor(red: 180/256, green: 180/256, blue: 180/256, alpha: 1).cgColor,
                                UIColor(red: 200/256, green: 200/256, blue: 200/256, alpha: 1).cgColor,
        UIColor(red: 180/256, green: 180/256, blue: 180/256, alpha: 1).cgColor,
        UIColor(red: 160/256, green: 160/256, blue: 160/256, alpha: 1).cgColor]
        gradientLayer.startPoint = .zero
        gradientLayer.endPoint = CGPoint(x: 1, y: 0) // horizontal from left to right
        gradientLayer.name = kMaskLayerName
        view.layer.addSublayer(gradientLayer)
        
        // Mask layer
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskablePath.cgPath
        gradientLayer.mask = maskLayer
        
        // Animation
        switch animationStyle {
        case .wave:
            gradientLayer.add(waveAnimation(locations: gradientLayer.locations), forKey: "wave-anim")
        case .fade:
            gradientLayer.add(fadeAnimationGroup(), forKey: "fade-anim")
        case .none:
            // don nothing
            break
        }
    }
    
    private func waveAnimation(locations: [NSNumber]?) -> CABasicAnimation{
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = locations
        animation.toValue = [1, 1.6, 1.6, 1.6, 2]
        animation.duration = 2
        animation.repeatCount = .infinity
        animation.isRemovedOnCompletion = false
        return animation
    }
    
    private func fadeAnimationGroup() -> CAAnimationGroup {
        let fadeOut = CABasicAnimation(keyPath: "opacity")
        fadeOut.fromValue = 1
        fadeOut.toValue = 0.3
        fadeOut.duration = 1

        let fadeIn = CABasicAnimation(keyPath: "opacity")
        fadeIn.fromValue = 0.3
        fadeIn.toValue = 1
        fadeIn.duration = 1
        fadeIn.beginTime = 1

        let group = CAAnimationGroup()
        group.duration = 2
        group.repeatCount = .infinity
        group.animations = [fadeOut, fadeIn]

        return group
    }
    
    /// Apply's a mask reflecting the UIView's shadow
    /// - Parameters:
    ///   - view: UIView
    ///   - tableViewCellIdenitifer: cellIdentifier if the view is a UITableView
    public func applyLoader(onView view: UIView, tableViewCellIdenitifer: String?, animationStyle: ShadowLoaderAnimationStyle = .wave) {
        // Remove loader first
        self.removeLoader(fromView: view)
        // show loader now
        self.cellIdentifier = tableViewCellIdenitifer
        self.animationStyle = animationStyle
        if let subLayers = view.layer.sublayers {
            for subLayer in subLayers{
                subLayer.opacity = 0.0
            }
        }
        self.fillPaths(view: view)
    }
    
    /// Remove's the mask applied as a loader view
    /// - Parameter view: UIView
    public func removeLoader(fromView view: UIView) {
        cellIdentifier = nil
        if let subLayers = view.layer.sublayers {
            for subLayer in subLayers{
                UIView.animate(withDuration: defaultAnimationDuration, animations: {
                    subLayer.opacity = 1.0
                })
                if subLayer.name == kMaskLayerName {
                    UIView.animate(withDuration: defaultAnimationDuration, animations: {
                        subLayer.removeFromSuperlayer()
                    })
                }
            }
        }
    }
    
    /// Returns true if loader is applied for the given view
    /// - Parameter view: UIView
    public func isMasking(view: UIView) -> Bool{
        if let subLayers = view.layer.sublayers {
            for subLayer in subLayers{
                if subLayer.name == kMaskLayerName {
                    return true
                }
            }
        }
        return false
    }
    
}
