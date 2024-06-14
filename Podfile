#source 'https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git'
platform :ios, '12.0'
#use_frameworks!
use_modular_headers!
inhibit_all_warnings!
install! 'cocoapods', :deterministic_uuids => false

target 'CLPopoverManagerDemo' do
    inhibit_all_warnings!
    pod 'LookinServer', :subspecs => ['Swift'], :configurations => ['Debug']
    pod 'SwiftFormat/CLI', :configurations => ['Debug']
    pod 'SnapKit'
    pod 'lottie-ios'
    pod 'DateToolsSwift'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['GCC_WARN_INHIBIT_ALL_WARNINGS'] = 'YES'
      if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 12.0
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
      end
    end
  end
end


