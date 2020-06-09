
Pod::Spec.new do |spec|

  spec.name         = "sdkApiVideo"
  spec.version      = "0.1.4"
  spec.summary      = "IOS client written in Swift for api.video service"
  spec.swift_version = "5.0"

  spec.description  = <<-DESC
The api.video web-service helps you put video on the web without the hassle. This documentation helps you use the corresponding IOS client. This is an early version, feel free to report any issue.
                   DESC

  spec.homepage     = "https://github.com/apivideo/ios-sdk"
  spec.license      = "Apache License, Version 2.0"
  spec.author       = { "romain petit" => "contact.romain.petit@gmail.com" }
  spec.platform     = :ios, "12.0"

  spec.source       = { :git => "https://github.com/apivideo/ios-sdk.git", :tag => "#{spec.version}" }
  spec.source_files  = "sdkApiVideo/Model/*.swift", "sdkApiVideo/Model/Analytics/*.swift" , "sdkApiVideo/API/*.swift"

  spec.dependency 'HaishinKit', '~> 1.0.4'
  spec.dependency 'Logboard', '~> 2.1.2'

  # fix GL deprecation warning
  spec.pod_target_xcconfig = { "SWIFT_ACTIVE_COMPILATION_CONDITIONS" => "GLES_SILENCE_DEPRECATION" }

end
