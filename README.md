# NBPhotoLibrary
Click and choose Photo and provides the cropping feature using RSKImageCropper libraryFor 

Add below line to podfile to integrate with PODS
   
    pod 'NBPhotoLibrary' 
# Code Example 
    #import "PhotoLibraryManager.h"

Add Delegate 

    <PhotoLibraryManagerDelegate>

Add below line to use lib 

    PhotoLibraryManager * photoLibrary = [PhotoLibraryManager instance];
    photoLibrary.delegate = self;
    photoLibrary.controller = self;
    [photoLibrary openPhotoLibrary];

We can user PhotoLibraryManagerDelegate method for usages

    - (void)photoLibraryImageCropController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect {
    self.imageView.image = croppedImage;
    }

