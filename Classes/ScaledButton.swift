//
//  ScaledButton.swift
//  MyLittlePinpad
//
//  Created by Anokhov Pavel on 07.03.2018.
//

import Foundation

@IBDesignable
class ScaledButton: RoundedButton {
	@IBInspectable
	public var imageScale: CGFloat = 0.7 {
		didSet {
			refreshScale()
		}
	}
	
	private func refreshScale() {
		contentHorizontalAlignment = .fill
		contentVerticalAlignment = .fill
		imageView?.contentMode = .scaleAspectFit
		let m = (bounds.width - bounds.width * imageScale) / 2
		imageEdgeInsets = UIEdgeInsets(top: m, left: m, bottom: m, right: m)
	}
	
	override var frame: CGRect {
		didSet {
			refreshScale()
		}
	}
	
	override var bounds: CGRect {
		didSet {
			refreshScale()
		}
	}
}
