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
#import "ProfileViewController.h"
#import "CommentViewController.h"

@interface HomeFeedViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, PostCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray *posts;
@property (assign, nonatomic) BOOL isMoreDataLoading;

@end

static void setImageBar(UINavigationItem *navigationItem) {
    UIImage *img = [UIImage imageNamed:@"instagramLetters.png"];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [imgView setImage:img];
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
    [self fetchPosts];
    [self initiateRefreshControl];
}

#pragma mark - UITableView delegate & data source

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    cell.delegate = self;
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

#pragma mark - PostCell delegate

- (void)performSegue:(NSString *)segueID didTap:(NSObject *)object{
    [self performSegueWithIdentifier:segueID sender:object];
}

# pragma mark - Action: logout

- (IBAction)didTapLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if(PFUser.currentUser == nil) {
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            appDelegate.window.rootViewController = loginViewController;
        } else {
            NSLog(@"Error logging out: %@", error);
        }
    }];
}

#pragma mark - HomeFeedViewController helper functions

- (void) fetchPosts {
    [self fetchPostsWithFilter: nil];
}

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
        if ([posts count] != 0) {
            if (lastDate) {
                self.isMoreDataLoading = false;
                [self.posts addObjectsFromArray:posts];
            } else {
                self.posts = posts;
            }
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

-(void) initiateRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview: self.refreshControl];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"profileSegue"]) {
        ProfileViewController *profileViewController = [segue destinationViewController];
        profileViewController.user = (PFUser*) sender;
    } else if ([segue.identifier isEqualToString:@"commentSegue"]) {
        CommentViewController *commentViewController = [segue destinationViewController];
        commentViewController.post = (Post*) sender;
    }else {
        PostDetailsViewController *postDetailsViewController = [segue destinationViewController];
        postDetailsViewController.post = (Post*) sender;

    }
}

@end
