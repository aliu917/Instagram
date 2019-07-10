//
//  ProfileViewController.m
//  Instagram
//
//  Created by aliu18 on 7/10/19.
//  Copyright © 2019 aliu18. All rights reserved.
//

#import "ProfileViewController.h"
#import "Parse/Parse.h"
#import "Post.h"
#import "UserPostCollectionCell.h"
#import "PostDetailsViewController.h"

@interface ProfileViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *profilePhoto;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *postCount;
@property (weak, nonatomic) IBOutlet UILabel *followerCount;
@property (weak, nonatomic) IBOutlet UILabel *followingCount;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *posts;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = [PFUser currentUser];
    self.postCount.text = [@(0) stringValue];
    self.followerCount.text = [@(0) stringValue];
    self.followingCount.text = [@(0) stringValue];
    
    
    PFFileObject *image = [self.user objectForKey:@"image"];
    
    //FIX LATER
    [image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!data) {
            return NSLog(@"%@", error);
        }
        self.profilePhoto.image = [UIImage imageWithData:data];
    }];

    
    
    
    
    
    
    self.username.text = self.user.username;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self formatLayout];
    [self fetchUserPosts];
}

- (IBAction)changeProfilePicture:(id)sender {
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    self.profilePhoto.image = editedImage;
    NSData *imageData = UIImageJPEGRepresentation(editedImage, 1);
    PFFileObject *imageFile = [PFFileObject fileObjectWithName:@"image.png" data: imageData];
    [imageFile saveInBackground];
    [self.user setObject:imageFile forKey:@"image"];
    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
        }
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UserPostCollectionCell *tappedCell = sender;
    PostDetailsViewController *postDetailsViewController = [segue destinationViewController];
    postDetailsViewController.post = tappedCell.post;
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UserPostCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UserPostCollectionCell" forIndexPath:indexPath];
    [cell setImage: self.posts[indexPath.item]];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.posts.count;
}

-(void) formatLayout {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;
    
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    CGFloat postersPerLine = 3;
    CGFloat itemWidth = (self.collectionView.frame.size.width - layout.minimumInteritemSpacing * (postersPerLine - 1)) / postersPerLine;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
}

-(void) fetchUserPosts {
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    [postQuery whereKey:@"author" equalTo:self.user];
    //postQuery.limit = 20;
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            //self.isMoreDataLoading = false;
            //[self.posts addObjectsFromArray:posts];
            self.posts = posts;
            [self.collectionView reloadData];
            
            self.postCount.text = [@(self.posts.count) stringValue];
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
        //[self.refreshControl endRefreshing];
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

@end
