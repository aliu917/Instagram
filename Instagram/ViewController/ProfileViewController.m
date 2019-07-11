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
#import "InstagramHelper.h"
#import "EditProfileViewController.h"

@interface ProfileViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profilePhoto;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *postCount;
@property (weak, nonatomic) IBOutlet UILabel *followerCount;
@property (weak, nonatomic) IBOutlet UILabel *followingCount;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *bio;
@property (strong, nonatomic) NSArray *posts;

@end

static void saveImageForUser(UIImage *editedImage, PFUser *user) {
    NSData *imageData = UIImageJPEGRepresentation(editedImage, 1);
    PFFileObject *imageFile = [PFFileObject fileObjectWithName:@"image.png" data: imageData];
    [imageFile saveInBackground];
    [user setObject:imageFile forKey:@"image"];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
        }
    }];
}

@implementation ProfileViewController

#pragma mark - ProfileViewController lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.user) {
        self.user = [PFUser currentUser];
    }
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.postCount.text = [@(0) stringValue];
    self.followerCount.text = [@(0) stringValue];
    self.followingCount.text = [@(0) stringValue];
    [InstagramHelper makeProfileImage: self.profilePhoto withUser: self.user];
    self.username.text = self.user.username;
    [self formatLayout];
    [self fetchUserPosts];
}

- (void) viewDidAppear:(BOOL)animated {
    self.bio.text = [self.user objectForKey:@"bio"];
}

#pragma mark - edit profile image

- (IBAction)changeProfilePicture:(id)sender {
    [InstagramHelper makeImagePicker: self];
}

#pragma mark - CollectionViewCell delegate & data source

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UserPostCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UserPostCollectionCell" forIndexPath:indexPath];
    [cell setImage: self.posts[indexPath.item]];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.posts.count;
}

#pragma mark - UIImagePickerController delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    self.profilePhoto.image = editedImage;
    saveImageForUser(editedImage, self.user);
    /*NSData *imageData = UIImageJPEGRepresentation(editedImage, 1);
    PFFileObject *imageFile = [PFFileObject fileObjectWithName:@"image.png" data: imageData];
    [imageFile saveInBackground];
    [self.user setObject:imageFile forKey:@"image"];
    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
        }
    }];*/
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
- (void) saveImage: (UIImage *) editedImage ForUser: (PFUser *) user {
    NSData *imageData = UIImageJPEGRepresentation(editedImage, 1);
    PFFileObject *imageFile = [PFFileObject fileObjectWithName:@"image.png" data: imageData];
    [imageFile saveInBackground];
    [user setObject:imageFile forKey:@"image"];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
        }
    }];
}*/

#pragma marl - ProfileViewController helper functions

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
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            self.posts = posts;
            [self.collectionView reloadData];
            
            self.postCount.text = [@(self.posts.count) stringValue];
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"editSegue"]) {
        EditProfileViewController *editViewController = [segue destinationViewController];
        editViewController.user = self.user;
    } else {
        UserPostCollectionCell *tappedCell = sender;
        PostDetailsViewController *postDetailsViewController = [segue destinationViewController];
        postDetailsViewController.post = tappedCell.post;
    }
}

@end
