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
	
	var roundingMode: RoundingMode {
		switch self {
		case .hidden:
			return .circle
			
		case .faceID:
			return .customRadius(radius: 13)
			
		case .touchID:
			return .circle
		}
	}
}
