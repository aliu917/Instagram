//
//  LikeDetailsViewController.m
//  Instagram
//
//  Created by aliu18 on 7/11/19.
//  Copyright © 2019 aliu18. All rights reserved.
//

#import "LikeDetailsViewController.h"
#import "LikedUserCell.h"
#import "ProfileViewController.h"

@interface LikeDetailsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (strong, nonatomic) NSDictionary *likedUsersDict;
//@property (strong, nonatomic) NSArray *likedUsers;

@end

@implementation LikeDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //self.likedUsersDict = [self.post objectForKey:@"likedUsersDict"];
    //self.likedUsers = [self.post objectForKey:@"likedUsers"];
    [self.tableView reloadData];
    // Do any additional setup after loading the view.
}

- (void) viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    LikedUserCell *tappedCell = sender;
    ProfileViewController *profileViewController = [segue destinationViewController];
    profileViewController.user = tappedCell.user;
}
*/

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    LikedUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LikedUserCell"];
    //NSDictionary *temp = self.likedUsersDict;
    //NSArray *users = [self.likedUsersDict allValues];
    //cell.username.text = users[indexPath.row];
    //[cell setUser: users[indexPath.row]];
    cell.text.text = self.likedUsers[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return [self.likedUsersDict count];
    return [self.likedUsers count];
}

- (IBAction)didTapClose:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
