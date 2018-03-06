//
//  PinpadViewController.swift
//  MyLittlePinpad
//
//  Created by Anokhov Pavel on 06.03.2018.
//

import UIKit

open class PinpadViewController: UIViewController {
	public static func instantiateFromNib() -> PinpadViewController {
		let bundle = Bundle(for: PinpadViewController.self)
		return bundle.loadNibNamed("PinpadViewController", owner: nil, options: nil)!.first as! PinpadViewController
	}

	// MARK: - Properties
	public weak var delegate: PinpadDelegate?
	
	/// Amount of digits in pincode
	public var pinCount: Int = 6 {
		didSet {
			remakePlaceholders(count: pinCount)
		}
	}
	
	/// Entered digits
	private(set) var pinDigits: [Int] = []
	
	public var pin: String {
		return pinDigits.map({String($0)}).joined()
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
				
				biometryButton.layer.cornerRadius = biometryButtonType.cornerRadiusFor(size: biometryButton.bounds.width)
				
				let bundle = Bundle(for: PinpadViewController.self)
				if let imageName = biometryButtonType.image, let image = UIImage(named: imageName, in: bundle, compatibleWith: nil) {
					biometryButton.setImage(image, for: .normal)
				}
			}
		}
	}
	
	// MARK: - IBOutlets
	// MARK: Digit buttons
	@IBOutlet var oneButton: RoundButton!
	@IBOutlet var twoButton: RoundButton!
	@IBOutlet var threeButton: RoundButton!
	@IBOutlet var fourButton: RoundButton!
	@IBOutlet var fiveButton: RoundButton!
	@IBOutlet var sixButton: RoundButton!
	@IBOutlet var sevenButton: RoundButton!
	@IBOutlet var eightButton: RoundButton!
	@IBOutlet var nineButton: RoundButton!
	@IBOutlet var zeroButton: RoundButton!
	@IBOutlet var backspaceButton: RoundButton!
	@IBOutlet var biometryButton: FlashingButton!
	
	internal lazy var buttons: [RoundButton] = {
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
	
	
	// MARK: Placeholders
	internal var placeholders: [PinPlaceholderView] = []
	
	public var placeholdersSize: CGFloat = 20 {
		didSet {
			remakePlaceholders(count: pinCount)
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
	
	
	// MARK: - Lifecycle
	override open func viewDidLoad() {
        super.viewDidLoad()
		
		bottomConstrain.constant = (self.view.bounds.width - mainStackView.bounds.width)/4
		
		for pin in placeholdersStackView.subviews.flatMap({$0 as? PinPlaceholderView}) {
			placeholders.append(pin)
		}
		
		remakePlaceholders(count: pinCount)
    }
	
	
	// MARK: - IBActions
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
	
	
	// MARK: - Pin
	private func pinAppend(digit: Int) {
		pinDigits.append(digit)
		
		refreshPlaceholders()
		
		if pinDigits.count >= pinCount {
			delegate?.pinpad(self, didEnterPin: pin)
		}
	}
	
	private func pinRemoveLatsDigit() {
		if pinDigits.count > 0 {
			pinDigits.removeLast()
		}
		
		refreshPlaceholders()
	}
	
	public func clearPin() {
		pinDigits.removeAll()
		refreshPlaceholders()
	}
	
	private func refreshPlaceholders() {
		let count = pinDigits.count
		
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
			for _ in placeholders.count..<count {
				let placeholder = PinPlaceholderView()
				placeholder.heightAnchor.constraint(equalToConstant: placeholdersSize).isActive = true
				placeholder.widthAnchor.constraint(equalToConstant: placeholdersSize).isActive = true
				
				placeholder.borderColor = bordersColor
				placeholder.borderWidth = bordersWidth
				placeholder.activeColor = placeholderActiveColor
				placeholders.append(placeholder)
				placeholdersStackView.addArrangedSubview(placeholder)
			}
		} else {
			for i in count..<placeholders.count {
				placeholders.remove(at: i)
			}
		}
	}
	
	
	// MARK: - Other
	
	
	/// Play wobble animation.
	///
	/// - Parameter feedback: play haptic 'Error' feedback. **Requires iOS 10 or later & iPhone 7 or later.**
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
}
