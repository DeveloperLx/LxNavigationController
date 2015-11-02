Pod::Spec.new do |s|
  s.name         = "LxNavigationController"
  s.version      = "1.0.0"
  s.summary      = "Add a powerful gesture you can pop view controller only if you sweep the screen from left the right"

  s.homepage     = "https://github.com/DeveloperLx/LxNavigationController"
  s.license      = 'Apache'
  s.authors      = { 'DeveloperLx' => 'developerlx@yeah.com' }
  s.platform     = :ios, "7.0"
  s.ios.deployment_target = "7.0"
  s.source       = { :git => "https://github.com/DeveloperLx/LxNavigationController.git", :tag => s.version}
  s.source_files = 'LxNavigationController/LxNavigationController.*'
  s.requires_arc = true
  s.frameworks   = 'Foundation', 'UIKit'
end
