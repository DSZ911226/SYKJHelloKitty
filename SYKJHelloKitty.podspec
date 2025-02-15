#
#  Be sure to run `pod spec lint SYKJHelloKitty.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  spec.name         = "SYKJHelloKitty"
  spec.version      = "0.0.2"
  spec.summary      = "个人使用库"

 

  spec.homepage     = "https://github.com/DSZ911226/SYKJHelloKitty.git"
  # spec.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See https://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

  spec.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  # spec.license      = { :type => "MIT", :file => "FILE_LICENSE" }



  spec.author             = { "dsz" => "dsz" }
 
  spec.platform     = :ios, "12.0"

  

  spec.source       = { :git => "https://github.com/DSZ911226/SYKJHelloKitty.git", :tag => "#{spec.version}" }


  spec.source_files = "SYKJHelloKitty","SYKJHelloKitty/**/*.{swift}"
  spec.resources     = 'SYKJHelloKitty/resources/*.png'

  


  

end
