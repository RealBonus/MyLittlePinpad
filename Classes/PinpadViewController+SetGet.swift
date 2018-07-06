//
//  PinpadViewController+.swift
//  MyLittlePinpad
//
//  Created by Anokhov Pavel on 07.03.2018.
//

import Foundation

// MARK: - Setters & Getters
extension PinpadViewController {
	
	// MARK: Border
	
	public var bordersWidth: CGFloat {
		get {
			return zeroButton.borderWidth
		}
		set {
			buttons.forEach {$0.borderWidth = newValue}
			placeholders.forEach {$0.borderWidth = newValue}
		}
	}
	
	public var bordersColor: UIColor? {
		get {
			return zeroButton.borderColor
		}
		set {
			buttons.forEach {$0.borderColor = newValue}
			placeholders.forEach {$0.borderColor = newValue}
		}
	}
	
	
	// MARK: Buttons color
	
	public var buttonsHighlightedColor: UIColor? {
		get {
			return zeroButton.highlightedBackgroundColor
		}
		set {
			buttons.forEach {$0.highlightedBackgroundColor = newValue}
			biometryButton.highlightedBackgroundColor = newValue
		}
	}
	
	public var buttonsBackgroundColor: UIColor? {
		get {
			return zeroButton.normalBackgroundColor
		}
		set {
			buttons.forEach {$0.normalBackgroundColor = newValue}
			placeholders.forEach {$0.backgroundColor = newValue}
			biometryButton.normalBackgroundColor = newValue
		}
	}
	
	public func setColor(_ color: UIColor?, for state: UIControlState) {
		buttons.forEach {$0.setTitleColor(color, for: state)}
		cancelButton.setTitleColor(color, for: state)
		
		if state == .normal {
			biometryButton.tintColor = color
		}
	}
	
	
	// MARK: Fonts
	
	public var buttonsFont: UIFont {
		get {
			return zeroButton.titleLabel!.font
		}
		set {
			buttons.forEach {$0.titleLabel!.font = newValue}
		}
	}
	
	
	// MARK: Buttons sizes
	
	public var buttonsSize: CGFloat {
		get {
			return zeroConstrain.constant
		}
		set {
			buttonsSizeConstrains.forEach {$0.constant = newValue}
			buttons.forEach {$0.layoutIfNeeded()}
		}
	}
	
	public var buttonsSpacing: CGFloat {
		get {
			return firstStackView.spacing
		}
		set {
			digitsStackViews.forEach {$0.spacing = newValue}
			mainStackView.spacing = newValue
		}
	}
	
	
	// MARK: Placeholders
	
	public var placeholdersSpacing: CGFloat {
		get {
			return placeholdersStackView.spacing
		}
		set {
			placeholdersStackView.spacing = newValue
		}
	}
	
	public var placeholderViewHeight: CGFloat {
		get {
			return placeholdersHeightConstrain.constant
		}
		set {
			placeholdersHeightConstrain.constant = newValue
		}
	}
	
	
	// MARK: Sizes
	
	public var bottomSpacing: CGFloat {
		get {
			return cancelButtonBottomConstrain.constant
		}
		set {
			cancelButtonBottomConstrain.constant = newValue
		}
	}
	
	public var pinpadToCancelSpacing: CGFloat {
		get {
			return pinpadToCancelConstrain.constant
		}
		set {
			pinpadToCancelConstrain.constant = newValue
		}
	}
}
