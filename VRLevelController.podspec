Pod::Spec.new do |s|
  s.name             = 'VRLevelController'
  s.version          = '1.0.0'
  s.swift_version    = '4.0'
  s.summary          = 'An iOS slider controller.'

  s.description      = <<-DESC
iOS slider controller for device volume handling or for your custom values
                       DESC

  s.homepage         = 'https://github.com/elchief84/VRLevelController'
  
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'vromano84' => 'vincenzo.romano@healthtouch.eu' }
  s.source           = { :git => 'https://github.com/elchief84/VRLevelController.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'VRLevelController/Classes/**/*'
  
end
