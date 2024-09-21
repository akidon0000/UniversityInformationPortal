# Uncomment the next line to define a global platform for your project
minimum_deployment_target = 15.0
platform :ios, minimum_deployment_target

install! 'cocoapods', :warn_for_unused_master_specs_repo => false

abstract_target 'All' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  inhibit_all_warnings!
  
  pod 'APIKit' , '~> 5'
  pod 'Kanna' , '~> 5'
  pod 'R.swift' , '~> 7'
  pod 'RxCocoa' , '~> 6'
  pod 'RxGesture' , '~> 4'
  pod 'RxSwift' , '~> 6'
  pod 'KeychainAccess' , '~> 4'
  pod 'NorthLayout'

  target 'univIP' do
  end

  target  'univIPTests' do
    inherit! :search_paths
  end
end

post_install do | installer |
  require 'fileutils'
  # 謝辞
  FileUtils.cp_r('Pods/Target Support Files/Pods-All-univIP/Pods-All-univIP-Acknowledgements.plist', 'univIP/Settings/Acknowledgements.plist', :remove_destination => true)

  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = minimum_deployment_target
      config.build_settings.delete 'ARCHS'
    end
  end
end
