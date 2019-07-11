//
//  CommentViewController.m
//  Instagram
//
//  Created by aliu18 on 7/11/19.
//  Copyright © 2019 aliu18. All rights reserved.
//

#import "CommentViewController.h"
#import "Parse/Parse.h"
#import "InstagramHelper.h"

@interface CommentViewController ()

@property (weak, nonatomic) IBOutlet UITextView *commentTextView;

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.commentTextView.delegate = self;
}
- (IBAction)didTapClose:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
- (IBAction)didTapComment:(id)sender {
    NSString *formattedText = [NSString stringWithFormat:@"%@", self.commentTextView.text];
    PFUser *currUser = [PFUser currentUser];
    NSMutableAttributedString *attrString = [InstagramHelper makeString: currUser.username withAppend: formattedText];
    NSString *finalizedComment = [attrString string];
    NSMutableArray *comments = [self.post objectForKey:@"commentsArray"];
    if (!comments) {
        comments = [[NSMutableArray alloc] init];
    }
    [comments addObject:finalizedComment];
    self.commentTextView.text = nil;
    [self.post setObject:comments forKey:@"commentsArray"];
    [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
        }
    }];
    [self didTapClose:nil];
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
