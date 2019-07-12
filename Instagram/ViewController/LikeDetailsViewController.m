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
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LikeDetailsViewController

#pragma mark - LikeDetailsViewController lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.titleLabel.text = [NSString stringWithFormat:@"Users who %@ this post", self.units];
    [self.tableView reloadData];
}

- (void) viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
}

#pragma mark - UITableView delegate and data source

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    LikedUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LikedUserCell"];
    cell.text.text = self.array[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.array count];
}

#pragma mark - Action: close view

- (IBAction)didTapClose:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
