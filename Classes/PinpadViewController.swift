//
//  PinpadViewController.swift
//  MyLittlePinpad
//
//  Created by Anokhov Pavel on 06.03.2018.
//

import UIKit

open class PinpadViewController: UIViewController {
	// MARK: - IBOutlets
	// MARK: Digit buttons
	@IBOutlet var oneButton: RoundedButton!
	@IBOutlet var twoButton: RoundedButton!
	@IBOutlet var threeButton: RoundedButton!
	@IBOutlet var fourButton: RoundedButton!
	@IBOutlet var fiveButton: RoundedButton!
	@IBOutlet var sixButton: RoundedButton!
	@IBOutlet var sevenButton: RoundedButton!
	@IBOutlet var eightButton: RoundedButton!
	@IBOutlet var nineButton: RoundedButton!
	@IBOutlet var zeroButton: RoundedButton!
	@IBOutlet var backspaceButton: RoundedButton!
	
	@IBOutlet var biometryButton: RoundedButton!
	
	internal lazy var buttons: [RoundedButton] = {
		return [oneButton, twoButton, threeButton, fourButton, fiveButton, sixButton, sevenButton, eightButton, nineButton, zeroButton, backspaceButton]
	}()
	
	// MARK: Digit constrains
	@IBOutlet var oneConstrain: NSLayoutConstraint!
	@IBOutlet var twoConstrain: NSLayoutConstraint!
	@IBOutlet var threeConstrain: NSLayoutConstraint!
	@IBOutlet var fourConstrain: NSLayoutConstraint!
	@IBOutlet var fiveConstrain: NSLayoutConstraint!
	@IBOutlet var sixConstrain: NSLayoutConstraint!
	@IBOutlet var sevenConstrain: NSLayoutConstraint!
	@IBOutlet var eightConstrain: NSLayoutConstraint!
	@IBOutlet var nineConstrain: NSLayoutConstraint!
	@IBOutlet var zeroConstrain: NSLayoutConstraint!
	@IBOutlet var biometryConstrain: NSLayoutConstraint!
	@IBOutlet var backspaceConstrain: NSLayoutConstraint!
	
	internal lazy var buttonsSizeConstrains: [NSLayoutConstraint] = {
		return [oneConstrain, twoConstrain, threeConstrain, fourConstrain, fiveConstrain, sixConstrain, sevenConstrain, eightConstrain, nineConstrain, zeroConstrain, biometryConstrain, backspaceConstrain]
	}()
	
	// MARK: Stacks
	@IBOutlet var mainStackView: UIStackView!
	@IBOutlet var placeholdersStackView: UIStackView!
	@IBOutlet var firstStackView: UIStackView!
	@IBOutlet var secondStackView: UIStackView!
	@IBOutlet var thirdStackView: UIStackView!
	@IBOutlet var fourthStackView: UIStackView!
	
	@IBOutlet var placeholdersWrap: UIView!
	
	internal lazy var digitsStackViews: [UIStackView] = {
		return [firstStackView, secondStackView, thirdStackView, fourthStackView]
	}()
	
	// MARK: Other
	@IBOutlet public weak var commentLabel: UILabel!
	@IBOutlet weak var cancelButton: UIButton!
	@IBOutlet var placeholdersHeightConstrain: NSLayoutConstraint!
	@IBOutlet var bottomConstrain: NSLayoutConstraint!
	@IBOutlet var background: UIView!
	public var backgroundView: UIView { return background }
	
	
	// MARK: - Properties
	public weak var delegate: PinpadViewControllerDelegate?
	
	/// Amount of digits in pincode. Default = 4
	public var pinDigits: Int = 4 {
		didSet {
			remakePlaceholders(count: pinDigits)
		}
	}
	
	/// Entered digits
	private(set) var digits: [Int] = []
	
	
	/// Entered pin
	public var pin: String {
		return digits.map({String($0)}).joined()
	}
	
	public var biometryButtonType: PinpadBiometryButtonType = .faceID {
		didSet {
			switch biometryButtonType {
			case .hidden:
				biometryButton.isHidden = true
				
			case .faceID:
				fallthrough
			case .touchID:
				biometryButton.isHidden = false
				
				let bundle = Bundle(for: PinpadViewController.self)
				if let imageName = biometryButtonType.image, let image = UIImage(named: imageName, in: bundle, compatibleWith: nil) {
					biometryButton.setImage(image, for: .normal)
					biometryButton.roundingMode = biometryButtonType.roundingMode
				}
			}
		}
	}
	
	
	// MARK: - Placeholders
	internal var placeholders: [PinPlaceholderView] = []
	
	public var placeholdersSize: CGFloat = 20 {
		didSet {
			remakePlaceholders(count: pinDigits)
		}
	}
	
	public var placeholderActiveColor: UIColor = .lightGray {
		didSet {
			placeholders.forEach {$0.activeColor = placeholderActiveColor}
		}
	}
	
	public var placeholderNormalColor: UIColor? {
		didSet {
			placeholders.forEach {$0.normalColor = placeholderNormalColor}
		}
	}
	
	// MARK: privates
	private func refreshPlaceholders() {
		let count = digits.count
		
		let animation = { [weak self] in
			guard let placeholders = self?.placeholders else {
				return
			}
			
			for i in 0..<placeholders.count {
				placeholders[i].isActive = i < count
			}
		}
		
		if Thread.isMainThread {
			UIView.animate(withDuration: 0.2, animations: animation)
		} else {
			DispatchQueue.main.async {
				UIView.animate(withDuration: 0.2, animations: animation)
			}
		}
	}
	
	private func remakePlaceholders(count: Int) {
		if count < 1 || count > 10 {
			return
		}
		
		if count > placeholders.count {
			placeholders.forEach({refreshPlaceholder($0)})
			
			for _ in placeholders.count..<count {
				let placeholder = PinPlaceholderView()
				
				placeholder.heightAnchor.constraint(equalToConstant: placeholdersSize).isActive = true
				placeholder.widthAnchor.constraint(equalToConstant: placeholdersSize).isActive = true
				placeholder.constraints.forEach({$0.identifier = "wh"})
				
				refreshPlaceholder(placeholder)
				placeholders.append(placeholder)
				placeholdersStackView.addArrangedSubview(placeholder)
			}
		} else {
			for _ in count..<placeholders.count {
				placeholders.removeLast().removeFromSuperview()
			}
			
			placeholders.forEach({refreshPlaceholder($0)})
		}
	}
	
	private func refreshPlaceholder(_ placeholder: PinPlaceholderView) {
		placeholder.constraints.filter({$0.identifier == "wh"}).forEach({$0.constant = placeholdersSize})
		
		placeholder.borderColor = bordersColor
		placeholder.borderWidth = bordersWidth
		placeholder.activeColor = placeholderActiveColor
	}
	
	// MARK: - Pin
	
	/// Clear digits, start again.
	public func clearPin() {
		digits.removeAll()
		refreshPlaceholders()
	}
	
	// MARK: privates
	internal func pinAppend(digit: Int) {
		guard digits.count < pinDigits else {
			return
		}
		
		digits.append(digit)
		
		refreshPlaceholders()
		
		if digits.count >= pinDigits {
			delegate?.pinpad(self, didEnterPin: pin)
		}
	}
	
	internal func pinRemoveLatsDigit() {
		if digits.count > 0 {
			digits.removeLast()
		}
		
		refreshPlaceholders()
	}
	
	
	// MARK: - Lifecycle
	override open func viewDidLoad() {
		super.viewDidLoad()
		
		bottomConstrain.constant = (self.view.bounds.width - firstStackView.bounds.width)/4
		
		for pin in placeholdersStackView.subviews.flatMap({$0 as? PinPlaceholderView}) {
			pin.borderColor = bordersColor
			placeholders.append(pin)
		}
		
		remakePlaceholders(count: pinDigits)
	}
	
	
	// MARK: - Animations
	
	/// Play wobble animation.
	///
	/// - Parameter feedback: play haptic 'Error' feedback. Default is true. **Requires iOS 10 or later & iPhone 7 or later.**
	public func playWrongPinAnimation(withHapticFeedback feedback: Bool = true) {
		let animation = CABasicAnimation(keyPath: "position")
		animation.duration = 0.05
		animation.repeatCount = 4
		animation.autoreverses = true
		animation.fromValue = NSValue(cgPoint: CGPoint(x: placeholdersStackView.center.x - 8, y: placeholdersStackView.center.y))
		animation.toValue = NSValue(cgPoint: CGPoint(x: placeholdersStackView.center.x + 8, y: placeholdersStackView.center.y))
		
		placeholdersStackView.layer.add(animation, forKey: "position")
		
		if feedback {
			if #available(iOS 10.0, *) {
				let notification = UINotificationFeedbackGenerator()
				notification.notificationOccurred(.error)
			}
		}
	}
}
