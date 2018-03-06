//
//  PinPlaceholderView.swift
//  MyLittlePinpad
//
//  Created by Anokhov Pavel on 06.03.2018.
//

import UIKit

@IBDesignable
open class PinPlaceholderView: UIView {
	// MARK: - Border properties
	
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
	
	override open var frame: CGRect {
		didSet {
			if frame.width < frame.height {
				layer.cornerRadius = frame.width / 2
			} else {
				layer.cornerRadius = frame.height / 2
			}
		}
	}
	
	override open var bounds: CGRect {
		didSet {
			if bounds.width < bounds.height {
				layer.cornerRadius = bounds.width / 2
			} else {
				layer.cornerRadius = bounds.height / 2
			}
		}
	}
	
	
	// MARK: - Other properties
	public var isActive: Bool = false {
		didSet {
			if oldValue != isActive {
				backgroundColor = isActive ? activeColor : normalColor
			}
		}
	}
	
	public var normalColor: UIColor? {
		didSet {
			if !isActive {
				backgroundColor = normalColor
			}
		}
	}
	
	public var activeColor: UIColor = .lightGray {
		didSet {
			if isActive {
				backgroundColor = activeColor
			}
		}
	}
}
