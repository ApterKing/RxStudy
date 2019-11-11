# Uncomment the next line to define a global platform for your project
source ‘https://github.com/CocoaPods/Specs.git’
platform :ios, '10.0'

target 'RxStudy' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for RxStudy
  pod 'RxSwift'
  pod 'RxCocoa'

end

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings.delete('CODE_SIGNING_ALLOWED')
    config.build_settings.delete('CODE_SIGNING_REQUIRED')
  end

  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['CONFIGURATION_BUILD_DIR'] = '$PODS_CONFIGURATION_BUILD_DIR'
    end
  end
end
