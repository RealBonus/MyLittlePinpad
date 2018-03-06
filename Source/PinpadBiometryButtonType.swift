//
//  PinpadBiometryButtonType.swift
//  MyLittlePinpad
//
//  Created by Anokhov Pavel on 06.03.2018.
//

import Foundation

public enum PinpadBiometryButtonType {
	case hidden
	case touchID
	case faceID
}

internal extension PinpadBiometryButtonType {
	var image: String? {
		switch self {
		case .hidden:
			return nil
			
		case .touchID:
			return "Touch ID"
			
		case .faceID:
			return "Face ID"
		}
	}
	
	func cornerRadiusFor(size: CGFloat) -> CGFloat {
		switch self {
		case .hidden:
			return 0
			
		case .touchID:
			return size/2
			
		case .faceID:
			return 9
		}
	}
}
