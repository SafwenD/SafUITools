//
//  WalkThroughModel.swift
//  SafUITools
//
//  Created by Safwen DEBBICHI on 26/12/2019.
//

import UIKit

public struct WalkThroughTip {
    var hightlightedView: UIView? // the view to highlight
    var customInfoView: UIView? // a custom info view for the tip
    var text: String? // text to show in a label as an info view
    var style: WalkThroughTipStyle // style of the tip
    public init(hightlightedView: UIView?, customInfoView: UIView? = nil, text: String?, style: WalkThroughTipStyle?) {
        self.hightlightedView = hightlightedView
        self.customInfoView = customInfoView
        self.text = text
        self.style = style ?? WalkThroughTipStyle()
    }
}
public struct WalkThroughTipStyle {
    var backgroundColor: UIColor // background color of the walkthrough
    var circlesColor: UIColor // color of the highlighting cirlces
    var infoLabelTextColor: UIColor // color of the info label
    var infoLabelBackgroundColor: UIColor // background color of the info label
    var shouldUseCircularHighlight: Bool // should use circular highlight or use default view frame
    public init(backgroundColor: UIColor? = UIColor.black.withAlphaComponent(0.7), circlesColor: UIColor? = .white, infoLabelTextColor: UIColor? = .black, infoLabelBackgroundColor: UIColor? = .white, shouldUseCircularHighlight: Bool = true) {
        self.backgroundColor = backgroundColor ?? UIColor.black.withAlphaComponent(0.7)
        self.circlesColor = circlesColor ?? .white
        self.infoLabelTextColor = infoLabelTextColor ?? UIColor(red: 100, green: 100, blue: 100, alpha: 1.0)
        self.infoLabelBackgroundColor = infoLabelBackgroundColor ?? UIColor.white.withAlphaComponent(0.5)
        self.shouldUseCircularHighlight = shouldUseCircularHighlight
    }
}
