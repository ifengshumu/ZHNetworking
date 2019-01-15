#
#  Be sure to run `pod spec lint ZHNetworking.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "ZHNetworking"
  s.version      = "1.0.0"
  s.summary      = "iOS网络操作"

  s.description  = "iOS网络操作：各种方式（GET、POST等）的请求、上传、下载"

  s.homepage     = "https://github.com/leezhihua/ZHNetworking"

  s.license      = { :type => "MIT", :file => "LICENSE" }



  s.author             = { "leezhihua" => "leezhihua@yeah.net" }

  s.platform     = :ios, "8.0"


  s.source       = { :git => "https://github.com/leezhihua/ZHNetworking.git", :tag => "#{s.version}" }


  s.source_files = "Pod/Classes/*.{h,m}"


  s.frameworks   = "Foundation"


  s.requires_arc = true

  s.dependency "AFNetworking"

end
