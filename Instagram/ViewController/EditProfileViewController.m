//
//  EditProfileViewController.m
//  Instagram
//
//  Created by aliu18 on 7/11/19.
//  Copyright © 2019 aliu18. All rights reserved.
//

#import "EditProfileViewController.h"
#import "Parse/Parse.h"

@interface EditProfileViewController ()

@property (weak, nonatomic) IBOutlet UITextView *bioTextView;
@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bioTextView.delegate = self;
}

#pragma mark - Action: close screen

- (IBAction)didTapClose:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - Action: Save bio

- (IBAction)didTapSave:(id)sender {
    NSString *formattedText = [NSString stringWithFormat:@"%@", self.bioTextView.text];
    self.bioTextView.text = nil;
    [self.user setObject:formattedText forKey:@"bio"];
    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
        }
    }];
    [self didTapClose:nil];
}

@end
