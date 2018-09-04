
Pod::Spec.new do |s|

  s.name         = "UKAnimation"
  s.version      = "0.0.1"
  s.summary      = "对CAAnimation进行了封装并且提供了一些简单的动画"

  s.homepage     = "https://github.com/AmyF/UKAnimation"
  s.license      = { :type => "Apache License 2.0", :file => "LICENSE" }

  s.author             = { "unko" => "840382477@qq.com" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/AmyF/UKAnimation", :tag => "#{s.version}" }
  s.source_files  = "Source", "Source/**/*.{swift}"

end
