//
//  ViewController.swift
//  MyLittlePinpad
//
//  Created by realbonus on 03/06/2018.
//  Copyright (c) 2018 realbonus. All rights reserved.
//

import UIKit
import MyLittlePinpad

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		
		DispatchQueue.main.async { [weak self] in
			self?.presentPinpad(self!)
		}
    }
	
	@IBAction func presentPinpad(_ sender: Any) {
		let pinpad = PinpadViewController.instantiateFromResourceNib()
		
		pinpad.delegate = self
		pinpad.buttonsSize = 87
		pinpad.buttonsSpacing = 20
		pinpad.placeholdersSpacing = 10
		pinpad.placeholdersSize = 25
		pinpad.pinDigits = 6
		pinpad.biometryButtonType = .faceID
		pinpad.bordersColor = UIColor.gray
		pinpad.buttonsHighlightedColor = UIColor.lightGray
		
		pinpad.commentLabel.text = "Lorem ipsum"
		pinpad.commentLabel.isHidden = false
		
		pinpad.setColor(UIColor.black, for: .normal)
		pinpad.setColor(UIColor.white, for: .highlighted)

		present(pinpad, animated: true, completion: nil)
	}
}

extension ViewController: PinpadViewControllerDelegate {
	func pinpad(_ pinpad: PinpadViewController, didEnterPin pin: String) {
		if pin != "000000" {
			pinpad.playWrongPinAnimation()
		}

		pinpad.clearPin()
	}

	func pinpadDidTapBiometryButton(_ pinpad: PinpadViewController) {
		print("Biometry!")
	}

	func pinpadDidCancel(_ pinpad: PinpadViewController) {
		pinpad.dismiss(animated: true, completion: nil)
	}
}

