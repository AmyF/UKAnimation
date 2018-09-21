
Pod::Spec.new do |s|

  s.name            = "UKAnimation"
  s.version         = "0.0.3"
  s.summary         = "UKAnimation对CAAnimation进行了封装并且提供了一些简单的动画"

  s.homepage        = "https://github.com/AmyF/UKAnimation"
  s.license         = { :type => "Apache License 2.0", :file => "LICENSE" }

  s.author          = { "unko" => "840382477@qq.com" }
  s.platform        = :ios, "9.0"
  s.source          = { :git => "https://github.com/AmyF/UKAnimation.git", :tag => s.version }
  s.source_files    = "Source", "Source/**/*.{swift,h,m}"
  s.swift_version   = "4.0"
  s.requires_arc    = true

end
