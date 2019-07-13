//
//  PhotoCaptureViewController.m
//  Instagram
//
//  Created by aliu18 on 7/9/19.
//  Copyright © 2019 aliu18. All rights reserved.
//

#import "PhotoCaptureViewController.h"
#import "Post.h"
#import "InstagramHelper.h"

@interface PhotoCaptureViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@property (weak, nonatomic) IBOutlet UITextView *caption;
@property (strong, nonatomic) UIImage *postImage;

@end

static UIImage * resizeImage(UIImage *image, CGSize size) {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


@implementation PhotoCaptureViewController

#pragma mark - PhotoCaptureViewController lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)getPicture:(id)sender {
    makeImagePicker(self);
}

#pragma mark - UIImagePickerController delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    self.postImage = resizeImage(editedImage, CGSizeMake(400, 400));
    self.selectImageView.image = self.postImage;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Action: post image and caption

- (IBAction)didTapPost:(id)sender {
    if (self.postImage == nil) {
        return;
    }
    self.caption.delegate = self;
    [Post postUserImage: self.postImage withCaption: self.caption.text withCompletion: nil];
    self.postImage = nil;
    self.caption.text = @"Enter a caption...";
    [self.tabBarController setSelectedIndex: 0];
}

@end
