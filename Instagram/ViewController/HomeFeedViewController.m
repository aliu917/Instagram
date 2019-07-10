//
//  HomeFeedViewController.m
//  Instagram
//
//  Created by aliu18 on 7/8/19.
//  Copyright © 2019 aliu18. All rights reserved.
//

#import "HomeFeedViewController.h"
#import "Parse/Parse.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "Post.h"
#import "PostCell.h"
#import "PostDetailsViewController.h"
#import "MBProgressHUD.h"

@interface HomeFeedViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray *posts;
@property (assign, nonatomic) BOOL isMoreDataLoading;
@end

#pragma mark - C helper functions

/*

static void fetchPostsWithFilter(NSDate *lastDate) {
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    if (lastDate) {
        [postQuery whereKey:@"createdAt" lessThan:lastDate];
    }
    postQuery.limit = 20;
    [MBProgressHUD showHUDAddedTo:refToSelf.view animated:YES];
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            refToSelf.isMoreDataLoading = false;
            [refToSelf.posts addObjectsFromArray:posts];
            [refToSelf.tableView reloadData];
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
        [refToSelf.refreshControl endRefreshing];
        [MBProgressHUD hideHUDForView:refToSelf.view animated:YES];
    }];
}
 */

static void setImageBar(UINavigationItem *navigationItem) {
    UIImage *img = [UIImage imageNamed:@"instagramLetters.png"];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [imgView setImage:img];
    // setContent mode aspect fit
    [imgView setContentMode:UIViewContentModeScaleAspectFit];
    navigationItem.titleView = imgView;
}

@implementation HomeFeedViewController

#pragma mark - HomeFeedViewController lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.posts = [[NSMutableArray alloc] init];
    setImageBar(self.navigationItem);
    //[self setImageBar];
    [self fetchPostsWithFilter:nil];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview: self.refreshControl];
}

#pragma mark - UITableView delegate & data source

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    [cell setPost: self.posts[indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!self.isMoreDataLoading){
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
            self.isMoreDataLoading = true;
            Post *lastPost = [self.posts lastObject];
            NSDate *lastDate = lastPost.createdAt;
            [self fetchPostsWithFilter:lastDate];
        }
    }
}
/*
-(void)loadMoreData{
 
    Post *lastPost = [self.posts lastObject];
    NSDate *lastDate = lastPost.createdAt;
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query whereKey:@"createdAt" lessThan:lastDate];
    query.limit = 20;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.isMoreDataLoading = false;
            [self.posts addObjectsFromArray:posts];
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
*/
/*
#pragma mark - Action: camera segue to UIImagePickerController

- (IBAction)didTapCamera:(id)sender {
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
*/
# pragma mark - Action: logout

- (IBAction)didTapLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
    }];
    AppDelegate *appDelegateTemp = (AppDelegate *) [UIApplication sharedApplication].delegate;
    
    LoginViewController* loginController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LoginViewController"];
    
    UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:loginController];
    appDelegateTemp.window.rootViewController = navigation;
}

#pragma mark - HomeFeedViewController helper functions

- (void) fetchPostsWithFilter: (NSDate *) lastDate {
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    if (lastDate) {
        [postQuery whereKey:@"createdAt" lessThan:lastDate];
    }
    postQuery.limit = 20;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            self.isMoreDataLoading = false;
            [self.posts addObjectsFromArray:posts];
            [self.tableView reloadData];
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
/*
- (void) fetchPosts {
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    postQuery.limit = 20;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    // fetch data asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            self.posts = posts;
            [self.tableView reloadData];
        }
        else {
            // handle error
        }
        [self.refreshControl endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
*//*
- (void) setImageBar {
    UIImage *img = [UIImage imageNamed:@"instagramLetters.png"];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [imgView setImage:img];
    // setContent mode aspect fit
    [imgView setContentMode:UIViewContentModeScaleAspectFit];
    self.navigationItem.titleView = imgView;
}*/
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    PostCell *tappedCell = sender;
    PostDetailsViewController *postDetailsViewController = [segue destinationViewController];
    postDetailsViewController.post = tappedCell.post;
}



@end
