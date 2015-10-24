#
# Be sure to run `pod lib lint SYSearchBar.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "SYSearchBar"
  s.version          = "0.1.1"
  s.summary          = "SSYSearchBar is just an AirBnb-like search bar."
  s.description      = "SSYSearchBar is just an AirBnb-like search bar, which implements its own UI logic instead of using the components of UIKit such as UISearchBar/UISearchController(iOS8+)/UISearchDisplayController(<iOS8)."

  s.homepage         = "https://github.com/seanyue/SYSearchBar"
  s.license          = 'MIT'
  s.author           = { "Yu Xulu(Sean Yue)" => "tonyfish@qq.com" }
  s.source           = { :git => "https://github.com/seanyue/SYSearchBar.git", :tag => s.version.to_s }
  s.social_media_url = 'http://weibo.com/sean2you'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource = 'Pod/Assets/**/*'

  s.public_header_files = 'Pod/Classes/*.h'
  s.private_header_files = 'Pod/Classes/Private/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
