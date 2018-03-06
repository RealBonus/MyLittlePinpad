//
//  PinpadDelegate.swift
//  MyLittlePinpad
//
//  Created by Anokhov Pavel on 06.03.2018.
//

import Foundation

public protocol PinpadDelegate: class {
	func pinpad(_ pinpad: PinpadViewController, didEnterPin pin: String)
	func pinpadDidTapBiometryButton(_ pinpad: PinpadViewController)
	func pinpadDidCancel(_ pinpad: PinpadViewController)
}
