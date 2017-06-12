
Pod::Spec.new do |s|

  s.name         = "NBPhotoLibrary"
  s.version      = "1.0"
  s.summary      = "Click and choose Photo and provides the cropping feature using RSKImageCropper library"
  s.description  = "This is Photo library to select photo and crop to set profile pic , this uses RSKImageCropper to crop"
  s.homepage     = "https://github.com/Nandaballabh"
  s.author             = { "Nanda Ballabh" => "nandaballabh.kec08@gmail.com" }
  s.platform     = :ios, "7.0"
  s.license      = { :type => 'Apache License 2.0', :file => 'LICENSE' }
  s.source       = { :git => "https://github.com/Nandaballabh/NBPhotoLibrary.git",:tag => s.version.to_s}
  s.requires_arc = true
  s.source_files = 'NBPhotoLibrary/*'
  s.dependency "RSKImageCropper"
end
