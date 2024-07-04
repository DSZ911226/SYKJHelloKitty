

Pod::Spec.new do |s|

  s.name         = "SYKJHelloKitty"
  s.version      = "0.0.1"
  s.summary      = "SYKJHelloKitty Crop Editor"
  s.homepage     = "https://github.com/DSZ911226/SYKJHelloKitty.git"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Apple" => "dsz" }
  s.platform     = :ios, '12.0'
  s.source       = { :git => "https://github.com/DSZ911226/SYKJHelloKitty.git", :tag => s.version }
  s.source_files = "SYKJHelloKitty/*.{swift}"
  s.resources     = 'SYKJHelloKitty/resources/*.png'
  s.exclude_files = "Classes/Exclude"


end
