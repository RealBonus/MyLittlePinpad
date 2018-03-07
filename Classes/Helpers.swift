//
//  Helpers.swift
//  MyLittlePinpad
//
//  Created by Anokhov Pavel on 07.03.2018.
//

import Foundation

extension PinpadViewController {
	/// Locate bundle with resources, load Nib file, and instantiate ViewController
	public static func instantiateFromResourceNib() -> PinpadViewController {
		var bundle = Bundle(for: PinpadViewController.self)
		
		if let url = bundle.url(forResource: "MyLittlePinpad", withExtension: "bundle"), let resourceBundle = Bundle(url: url) {
			bundle = resourceBundle
		}
		
		if Thread.isMainThread {
			return bundle.loadNibNamed("PinpadViewController", owner: nil, options: nil)!.first as! PinpadViewController
		} else {
			var controller: PinpadViewController! = nil
			DispatchQueue.main.sync {
				controller = bundle.loadNibNamed("PinpadViewController", owner: nil, options: nil)!.first as! PinpadViewController
			}
			return controller
		}
	}
}
