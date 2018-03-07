//
//  PinpadViewController+IBAction.swift
//  MyLittlePinpad
//
//  Created by Anokhov Pavel on 07.03.2018.
//

import Foundation

extension PinpadViewController {
	@IBAction func oneTapped(sender: UIButton) {
		pinAppend(digit: 1)
	}
	
	@IBAction func twoTapped(sender: UIButton) {
		pinAppend(digit: 2)
	}
	
	@IBAction func threeTapped(sender: UIButton) {
		pinAppend(digit: 3)
	}
	
	@IBAction func fourTapped(sender: UIButton) {
		pinAppend(digit: 4)
	}
	
	@IBAction func fiveTapped(sender: UIButton) {
		pinAppend(digit: 5)
	}
	
	@IBAction func sixTapped(sender: UIButton) {
		pinAppend(digit: 6)
	}
	
	@IBAction func sevenTapped(sender: UIButton) {
		pinAppend(digit: 7)
	}
	
	@IBAction func eightTapped(sender: UIButton) {
		pinAppend(digit: 8)
	}
	
	@IBAction func nineTapped(sender: UIButton) {
		pinAppend(digit: 9)
	}
	
	@IBAction func zeroTapped(sender: UIButton) {
		pinAppend(digit: 0)
	}
	
	@IBAction func backspaceTapped(sender: UIButton) {
		pinRemoveLatsDigit()
	}
	
	@IBAction func biometryTapped(sender: UIButton) {
		delegate?.pinpadDidTapBiometryButton(self)
	}
	
	@IBAction func cancelTapped(sender: UIButton) {
		delegate?.pinpadDidCancel(self)
	}
}
