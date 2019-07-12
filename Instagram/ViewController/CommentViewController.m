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

#pragma mark - CommentViewController lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.commentTextView.delegate = self;
}

#pragma mark - Action: close view

- (IBAction)didTapClose:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - Action: make comment

- (IBAction)didTapComment:(id)sender {
    NSString *formattedText = [NSString stringWithFormat:@"%@", self.commentTextView.text];
    PFUser *currUser = [PFUser currentUser];
    NSMutableAttributedString *attrString = makeStringwithAppend(currUser.username, formattedText);
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

@end
