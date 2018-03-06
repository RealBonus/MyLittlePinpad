#
# Be sure to run `pod lib lint MyLittlePinpad.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MyLittlePinpad'
  s.version          = '0.1.0'
  s.summary          = 'My Little minimalistic pinpad! Need a pincode from a user? Got it!'

  s.description      = 'Simple minimalistic pinpad for entering pincodes. With a magic biometry button.'

  s.homepage         = 'https://github.com/realbonus/MyLittlePinpad'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'realbonus' => 'p.anokhov@gmail.com' }
  s.source           = { :git => 'https://github.com/realbonus/MyLittlePinpad.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.3'

  s.source_files = 'MyLittlePinpad/Classes/**/*'
  
  s.resource_bundles = {
    'MyLittlePinpad' => [
		'Assets/PinpadViewController.xib',
		'Assets/icons.xcassets/Face ID.imageset/*.png',
		'Assets/icons.xcassets/Touch ID.imageset/*.png'
	]
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'MapKit'
end
