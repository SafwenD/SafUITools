//
//  TinyToast.swift
//  SafUITools
//
//  Created by Safwen DEBBICHI on 30/12/2019.
//

import UIKit

public enum ToastSlidingDirection {
    case fromBottom, fromTop
}
@available (iOS 11.0, *)
public class TinyToast: UIView {
    public static let kTinyToastTag: Int = 1992923
    public var edgeSpacing: CGFloat = 32.0
    public var text: String? {
        return label.text
    }
    var animationDirection: ToastSlidingDirection
    var animationDuration: TimeInterval = 0.35
    var lifeTime: TimeInterval?
    var label: PaddingLabel = PaddingLabel(withInsets: 8, 8, 8, 8)
    init(withText text: String, font: UIFont = UIFont.systemFont(ofSize: 16), backgroundColor: UIColor = UIColor.black.withAlphaComponent(0.4), textColor: UIColor = .white, animationDirection: ToastSlidingDirection = .fromBottom, disappearAfter: TimeInterval? = nil) {
        self.animationDirection = animationDirection
        self.lifeTime = disappearAfter
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.addSubview(label)
        self.label.text = text
        self.label.textColor = textColor
        self.label.font = font
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        self.label.textAlignment = .center
        self.label.numberOfLines = 0
        self.positionLabel()
    }
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func removeAnimated() {
        let affineTransfrom = CGAffineTransform(translationX: 0, y: animationDirection == .fromBottom ? -150 : 150)
        UIView.animate(withDuration: animationDuration , delay: 0, options: [], animations: { [weak self] in
            self?.transform = affineTransfrom
            self?.alpha = 0
        }, completion: { (_) in
            self.removeFromSuperview()
        })
    }
    private func positionLabel() {
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.label.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        self.label.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard let _superView = self.superview else { return }
        // size that fits the screen
        let sizeThatFits = label.sizeThatFits(_superView.bounds.size)
        var affineTransfrom: CGAffineTransform?
        switch animationDirection {
        case .fromBottom:
            self.bottomAnchor.constraint(equalTo: _superView.safeAreaLayoutGuide.bottomAnchor, constant: edgeSpacing).isActive = true
            affineTransfrom = CGAffineTransform(translationX: 0, y: -1 * (edgeSpacing + sizeThatFits.height))
            break
        case .fromTop:
            self.topAnchor.constraint(equalTo: _superView.safeAreaLayoutGuide.topAnchor, constant: -1 * sizeThatFits.height).isActive = true
            affineTransfrom = CGAffineTransform(translationX: 0, y: (edgeSpacing + sizeThatFits.height))
            break
        }
        
        if let unwrappedTransform = affineTransfrom {
            UIView.animate(withDuration: animationDuration, delay: 0, options: [], animations: { [weak self] in
                self?.transform = unwrappedTransform
            }, completion: { (_) in
                if let duration = self.lifeTime {
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
                        UIView.transition(with: _superView, duration: self?.animationDuration ?? 0.0, options: [.transitionCrossDissolve], animations: {
                            self?.removeFromSuperview()
                        }, completion: nil)
                    }
                }
            })
        }
    }
}
