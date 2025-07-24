Pod::Spec.new do |s|
  s.name         = 'CLPopoverManager'
  s.version      = '0.0.3'
  s.summary      = 'CLPopoverManager'
  s.homepage     = 'https://github.com/JmoVxia/CLPopoverManager'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.authors      = {'JmoVxia' => 'JmoVxia@gmail.com'}
  s.ios.deployment_target = '13.0'
  s.source       = {:git => 'https://github.com/JmoVxia/CLPopoverManager', :tag => s.version}
  s.source_files = ['CLPopoverManager/**/*']
  s.swift_versions = ['5.0']
  s.requires_arc = true
end
