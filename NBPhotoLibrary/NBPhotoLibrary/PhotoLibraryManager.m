//
//  PhotoLibraryManager.m
//  Toggr
//
//  Created by Nanda Ballabh on 12/06/17.
//  Copyright © 2017 nandaballabh. All rights reserved.
//

#import "PhotoLibraryManager.h"
#import <AVFoundation/AVFoundation.h>

@interface PhotoLibraryManager()<UIActionSheetDelegate , UIImagePickerControllerDelegate,UINavigationControllerDelegate,RSKImageCropViewControllerDelegate>


@end

@implementation PhotoLibraryManager

static PhotoLibraryManager * _inatance = nil;
+ (instancetype) instance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _inatance = [[PhotoLibraryManager alloc]init];
    });
    return _inatance;
}

- (void)openPhotoLibrary {
    
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Photo Album", @""),NSLocalizedString(@"Camera", @""), nil];
    [actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", @"")];
    actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

#pragma mark UIActionSheetDelegate method

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:NSLocalizedString(@"Photo Album", @"")]) {
        [self pickFromPhotoAlbum];
        
    } else if ([buttonTitle isEqualToString:NSLocalizedString(@"Camera", @"")]) {
        [self checkForTheCameraPermission];
    }
}




- (void) pickFromPhotoAlbum {
    if([self.delegate respondsToSelector:@selector(photoLibraryDidOpen:)])
        [self.delegate photoLibraryDidOpen:self];
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    controller.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.controller presentViewController:controller animated:YES completion:NULL];
    
}


#pragma  mark open camera to click photo

- (void) openCamera {
    
    if([self.delegate respondsToSelector:@selector(cameraDidOpen:)])
        [self.delegate cameraDidOpen:self];

    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    controller.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.controller presentViewController:controller animated:YES completion:NULL];
    
}


#pragma  mark pick photo from photo album method

- (void) checkForTheCameraPermission {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *inputError = nil;
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&inputError];
    
    // Camera restriction check
    if(!deviceInput && inputError.code == AVErrorDeviceNotConnected) {
        [self camRestrict];
        return;
    }
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusAuthorized)
        [self openCamera];
    else if (authStatus == AVAuthorizationStatusDenied)
        [self camDenied];
    else if(authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted)
         {
             if(granted)
                 [self openCamera];
             else
                 [self camDenied];
             
         }];
    } else if(authStatus == AVAuthorizationStatusRestricted)
        [self camRestrict];
    
}


-(void)camDenied {
    BOOL canOpenSettings = (&UIApplicationOpenSettingsURLString != NULL);
    NSString * message = @"";
    id alertDelegate = nil;
    BOOL isEnableButton = NO;
    if(canOpenSettings) {
        message = NSLocalizedString(@"Tap on Enable button > Privacy > Turn on camera", @"");
        alertDelegate = self;
        isEnableButton = YES;
    } else {
        message = NSLocalizedString(@"Go to Settings > Privacy > Camera and turn on __APPNAME__", @"");
        isEnableButton = NO;
    }
    
    NSString * appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
    message = [message stringByReplacingOccurrencesOfString:@"__APPNAME__" withString:appName];
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Access denied", @"") message:message delegate:alertDelegate cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
    if(isEnableButton)
        [alert addButtonWithTitle:NSLocalizedString(@"Enable", @"")];
    [alert show];
}

-(void)camRestrict {
    
    NSString * appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
    NSString * message = NSLocalizedString(@"Go to General > Restriction > Provide passcode > Turn on camera", @"");
    message = [message stringByReplacingOccurrencesOfString:@"__APPNAME__" withString:appName];
    
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Camera restricted", @"") message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
    [alert show];
}


#pragma mark alertView delegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        
        BOOL canOpenSettings = (&UIApplicationOpenSettingsURLString != NULL);
        if (canOpenSettings)
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}


#pragma  mark UIImagePickerController delegate method

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    if([self.delegate respondsToSelector:@selector(photoLibrary:didFinishPickingMediaWithInfo:)])
        [self.delegate photoLibrary:picker didFinishPickingMediaWithInfo:info];
    [picker dismissViewControllerAnimated:YES completion:^{
        // Open RSKImageEditor
        RSKImageCropViewController *imageCropViewController = [[RSKImageCropViewController alloc] initWithImage:image cropMode:RSKImageCropModeCircle];
        imageCropViewController.delegate = self;
        imageCropViewController.avoidEmptySpaceAroundImage = YES;
        [self.controller presentViewController:imageCropViewController animated:YES completion:nil];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    if([self.delegate respondsToSelector:@selector(photoLibraryDidCancel:)])
        [self.delegate photoLibraryDidCancel:picker];
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - RSKImageCropViewControllerDelegate

- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    if([self.delegate respondsToSelector:@selector(photoLibraryDidCancelCrop:)])
        [self.delegate photoLibraryDidCancelCrop:controller];
    [self.controller dismissViewControllerAnimated:YES completion:^{
        
    }];

}


- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect {

    if([self.delegate respondsToSelector:@selector(photoLibraryImageCropController:didCropImage:usingCropRect:)])
        [self.delegate photoLibraryImageCropController:controller didCropImage:croppedImage usingCropRect:cropRect];
    [self.controller dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
