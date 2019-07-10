//
//  PhotoCaptureViewController.m
//  Instagram
//
//  Created by aliu18 on 7/9/19.
//  Copyright © 2019 aliu18. All rights reserved.
//

#import "PhotoCaptureViewController.h"
#import "Post.h"

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

#pragma mark - PhotoCaptureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)getPicture:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePickerVC animated:YES completion:nil];
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
    self.caption.delegate = self;
    [Post postUserImage: self.postImage withCaption: self.caption.text withCompletion: nil];
    [self.tabBarController setSelectedIndex: 0];
}


#pragma mark - PhotoCaptureViewController helper functions

/*
- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
*/
/*
-(CGSize *) makeCGSize: (UIImage *) image {
    CGSize imageSize = CGSizeMake(image.size.width * image.scale, image.size.height * image.scale);
    CGFloat bytesPerPixel = 4.0;
    CGFloat bytesPerSize = imageSize.width * imageSize.height;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
