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
#import "LogInViewController.h"

@interface HomeFeedViewController ()

@end

@implementation HomeFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)didTapLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
    }];
    AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
    
    LogInViewController* loginController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LogInViewController"];
    
    UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:loginController];
    appDelegateTemp.window.rootViewController = navigation;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
