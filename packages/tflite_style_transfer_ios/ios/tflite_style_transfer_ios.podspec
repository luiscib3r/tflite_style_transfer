#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'tflite_style_transfer_ios'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter plugin project.'
  s.description      = <<-DESC
A new Flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  
  s.dependency 'Flutter'
  s.dependency 'TensorFlowLiteSwift'
  s.dependency 'TensorFlowLiteSwift/CoreML'
  s.dependency 'TensorFlowLiteSwift/Metal'
  
  s.platform = :ios, '10.0'
  s.ios.deployment_target = '10.0'
  s.static_framework = true

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386 arm64' }
  s.swift_version = '5.0'

  s.script_phases = [
    { 
      :name => 'Download tflite models',
      :script => '${PODS_TARGET_SRCROOT}/download_tflite_models.sh',
      :execution_position => :before_compile
    }
  ]

  s.resources = [
    'Assets/*.tflite'
  ]
end
