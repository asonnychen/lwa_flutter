#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint lwa.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'lwa'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter plugin project.'
  s.description      = <<-DESC
A new Flutter plugin project.
                       DESC
  s.homepage         = 'https://firedance.io'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Firedance Multimeida LLC' => 'support@firedance.io' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  s.preserve_paths = 'LoginWithAmazon.framework/**/*'
  s.xcconfig = { 'OTHER_LDFLAGS' => '-framework LoginWithAmazon' }
  s.vendored_frameworks = 'LoginWithAmazon.framework'
end
