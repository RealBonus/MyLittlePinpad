//
//  RoundedButton.swift
//  MyLittlePinpad
//
//  Created by Anokhov Pavel on 06.03.2018.
//

import UIKit

public enum RoundingMode {
	case none
	case circle
	case customRadius(radius: CGFloat)
}


@IBDesignable
open class RoundedButton: UIButton {
	// MARK: Configuring border
	@IBInspectable
	open var borderWidth: CGFloat {
		set {
			if newValue < 0 {
				layer.borderWidth = 0
			} else {
				layer.borderWidth = newValue
			}
		}
		get {
			return layer.borderWidth
		}
	}
	
	@IBInspectable
	open var borderColor: UIColor? {
		set {
			layer.borderColor = newValue?.cgColor
		}
		get {
			if let borderColor = layer.borderColor {
				return UIColor(cgColor: borderColor)
			} else {
				return nil
			}
		}
	}
	
	// MARK: - Frame
	open var roundingMode: RoundingMode = .circle {
		didSet {
			setNeedsDisplay()
		}
	}
	
	override open var frame: CGRect {
		didSet {
			switch roundingMode {
			case .none:
				layer.cornerRadius = 0
				
			case .circle:
				if frame.width < frame.height {
					layer.cornerRadius = frame.width / 2
				} else {
					layer.cornerRadius = frame.height / 2
				}
				
			case .customRadius(let radius):
				layer.cornerRadius = radius
			}
		}
	}
	
	override open var bounds: CGRect {
		didSet {
			switch roundingMode {
			case .none:
				layer.cornerRadius = 0
				
			case .circle:
				if bounds.width < bounds.height {
					layer.cornerRadius = bounds.width / 2
				} else {
					layer.cornerRadius = bounds.height / 2
				}
				
			case .customRadius(let radius):
				layer.cornerRadius = radius
			}
		}
	}
	
	
	// MARK: - Flashing
    open var highlightedBackgroundColor: UIColor? {
        didSet {
            if isHighlighted {
                backgroundColor = highlightedBackgroundColor
            }
        }
    }
    
    open var normalBackgroundColor: UIColor? = nil {
        didSet {
            if !isHighlighted {
                backgroundColor = normalBackgroundColor
            }
        }
    }
	
	override open var isHighlighted: Bool {
		didSet {
			if let color = highlightedBackgroundColor {
				backgroundColor = isHighlighted ? color : normalBackgroundColor
			}
		}
	}
}
