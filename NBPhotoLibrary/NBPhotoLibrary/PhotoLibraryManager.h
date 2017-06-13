//
//  PhotoLibraryManager.h
//  NBPhotoLibrary
//
//  Created by Nanda Ballabh on 12/06/17.
//  Copyright © 2017 nandaballabh. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "RSKImageCropViewController.h"

@protocol PhotoLibraryManagerDelegate;

@interface PhotoLibraryManager : NSObject

@property (strong , nonatomic) id<PhotoLibraryManagerDelegate>  delegate;

@property (nonatomic , strong) UIViewController * controller;

+ (instancetype) instance;

- (void)openPhotoLibrary;

@end

@protocol PhotoLibraryManagerDelegate <NSObject>

@optional

- (void)photoLibraryDidOpen:(PhotoLibraryManager *) library;

- (void)cameraDidOpen:(PhotoLibraryManager *) library;

- (void)photoLibrary:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;

- (void)photoLibraryDidCancel:(UIImagePickerController *)picker;

- (void)photoLibraryDidCancelCrop:(RSKImageCropViewController *)controller;

- (void)photoLibraryImageCropController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect;

@end
