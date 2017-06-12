//
//  ViewController.m
//  NBPhotoLibrary
//
//  Created by Nanda Ballabh on 12/06/17.
//  Copyright © 2017 nandaballabh. All rights reserved.
//

#import "ViewController.h"
#import "PhotoLibraryManager.h"

@interface ViewController ()<PhotoLibraryManagerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)photoTapped:(id)sender {
    PhotoLibraryManager * photoLibrary = [PhotoLibraryManager instance];
    photoLibrary.delegate = self;
    photoLibrary.controller = self;
    [photoLibrary openPhotoLibrary];
}

#pragma - mark PhotoLibraryManagerDelegate methods

- (void)photoLibraryImageCropController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect {
    self.imageView.image = croppedImage;
}

@end
