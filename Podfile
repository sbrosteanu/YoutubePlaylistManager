# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target 'PlaylistManager' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for PlaylistManager
  pod 'Google/SignIn'
  pod 'Alamofire', '~> 4.0'
  pod 'AlamofireImage', '~> 3.0'
  pod 'PromiseKit', '~> 4.0'
  pod 'ObjectMapper', '~> 2.2'
  pod 'ReactiveCocoa', '5.0.0-alpha.3'
end
post_install do |installer|
	installer.pods_project.targets.each do |target|
		target.build_configurations.each do |config|
			config.build_settings['SWIFT_VERSION'] = '3.0'
		end
	end
end
