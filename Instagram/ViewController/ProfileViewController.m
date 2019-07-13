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
@property (weak, nonatomic) IBOutlet UIImageView *plusImage;
@property (weak, nonatomic) IBOutlet UIButton *editBioButton;
@property (strong, nonatomic) NSArray *posts;
@property (nonatomic) BOOL *allowEdit;

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

static void formatLayout(UICollectionView *collectionView) {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) collectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    CGFloat postersPerLine = 3;
    CGFloat itemWidth = (collectionView.frame.size.width - layout.minimumInteritemSpacing * (postersPerLine - 1)) / postersPerLine;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
}

@implementation ProfileViewController

#pragma mark - ProfileViewController lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.allowEdit = NO;
    if (!self.user) {
        self.allowEdit = YES;
        self.user = [PFUser currentUser];
    }
    PFUser *currUser = [PFUser currentUser];
    if (!self.allowEdit) {
        self.plusImage.hidden = YES;
        self.editBioButton.hidden = YES;
    }
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.postCount.text = [@(0) stringValue];
    self.followerCount.text = [@(0) stringValue];
    self.followingCount.text = [@(0) stringValue];
    makeProfileImagewithUser(self.profilePhoto, self.user);
    self.username.text = self.user.username;
    formatLayout(self.collectionView);
    [self fetchUserPosts];
}

- (void) viewDidAppear:(BOOL)animated {
    NSLog(@"Reloading");
    self.bio.text = [self.user objectForKey:@"bio"];
    makeProfileImagewithUser(self.profilePhoto, self.user);
    [self fetchUserPosts];
}

#pragma mark - Action: edit profile image

- (IBAction)changeProfilePicture:(id)sender {
    if (self.allowEdit) {
        makeImagePicker(self);
    }
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ProfileViewController helper functions

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
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

#pragma mark - Navigation

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
