//
//  DimmedView.swift
//  PanModal
//
//  Copyright © 2017 Tiny Speck, Inc. All rights reserved.
//

#if os(iOS)
import UIKit

/**
 A dim view for use as an overlay over content you want dimmed.
 */
public class DimmedView: UIView {

    /**
     Represents the possible states of the dimmed view.
     max, off or a percentage of dimAlpha.
     */
    enum DimState {
        case max
        case off
        case percent(CGFloat)
    }
    
    public enum DimConfig {
        case backgroundColor(color: UIColor)
        case visualEffect(effect: UIBlurEffect, opacity: Float)
    }

    // MARK: - Properties

    /**
     The state of the dimmed view
     */
    var dimState: DimState = .off {
        didSet {
            switch dimState {
            case .max:
                alpha = 1.0
            case .off:
                alpha = 0.0
            case .percent(let percentage):
                alpha = max(0.0, min(1.0, percentage))
            }
        }
    }

    /**
     The closure to be executed when a tap occurs
     */
    var didTap: ((_ recognizer: UIGestureRecognizer) -> Void)?

    /**
     Tap gesture recognizer
     */
    private lazy var tapGesture: UIGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(didTapView))
    }()

    // MARK: - Initializers

    init(frame: CGRect, dimConfig: DimConfig = .backgroundColor(color: UIColor.black.withAlphaComponent(0.7))) {
        super.init(frame: frame)
        alpha = 0.0
        switch dimConfig {
        case .backgroundColor(color: let color):
            backgroundColor = color
        case .visualEffect(effect: let effect, opacity: let opacity):
            let effectView = UIVisualEffectView(frame: frame)
            addSubview(effectView)
            effectView.effect = effect
            effectView.layer.opacity = opacity
        }
        addGestureRecognizer(tapGesture)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    // MARK: - Event Handlers

    @objc private func didTapView() {
        didTap?(tapGesture)
    }

}
#endif
