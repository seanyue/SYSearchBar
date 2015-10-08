#
# Be sure to run `pod lib lint SYSearchBar.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "SYSearchBar"
  s.version          = "0.1.0"
  s.summary          = "A short description of SYSearchBar."
  s.description      = "SYSearchBar description"

  s.homepage         = "https://github.com/<GITHUB_USERNAME>/SYSearchBar"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Yu Xulu" => "tonyfish@qq.com" }
  s.source           = { :git => "https://github.com/<GITHUB_USERNAME>/SYSearchBar.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource = 'Pod/Assets/**/*'

  s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
