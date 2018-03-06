//
//  FlashingButton.swift
//  MyLittlePinpad
//
//  Created by Anokhov Pavel on 06.03.2018.
//

import UIKit

open class FlashingButton: UIButton {
	open var highlightedBackgroundColor: UIColor?
	open var normalBackgroundColor: UIColor? = nil
	
	override open var isHighlighted: Bool {
		didSet {
			if let color = highlightedBackgroundColor {
				backgroundColor = isHighlighted ? color : normalBackgroundColor
			}
		}
	}
}
