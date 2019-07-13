//
//  InstagramHelper.m
//  Instagram
//
//  Created by aliu18 on 7/9/19.
//  Copyright © 2019 aliu18. All rights reserved.
//

#import "InstagramHelper.h"
#import <UIKit/UIKit.h>
#import "Post.h"

#pragma mark - String formatting helpers

NSString * formatDate(NSDate *createdAtOriginalString) {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDate *todayDate = [NSDate date];
    double ti = [createdAtOriginalString timeIntervalSinceDate:todayDate];
    ti = ti * -1;
    if(ti < 1) {
        return @"0 sec ago";
    } else  if (ti < 60) {
        return [NSString stringWithFormat:@"%.00f sec ago", ti];
    } else if (ti < 3600) {
        int diff = round(ti / 60);
        return [NSString stringWithFormat:@"%d min ago", diff];
    } else if (ti < 86400) {
        int diff = round(ti / 60 / 60);
        return[NSString stringWithFormat:@"%d hrs ago", diff];
    } else {
        formatter.dateStyle = NSDateFormatterShortStyle;
        formatter.timeStyle = NSDateFormatterNoStyle;
        return [formatter stringFromDate:createdAtOriginalString];
    }
}

NSMutableAttributedString* makeStringwithAppend(NSString *username, NSString *caption) {
    NSString *frontAddSpace = [username stringByAppendingString:@" "];
    NSString *fullText = [frontAddSpace stringByAppendingString:caption];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:fullText];
    NSRange boldRange = [fullText rangeOfString:username];
    [attrString addAttribute: NSFontAttributeName value:[UIFont boldSystemFontOfSize:20] range:boldRange];
    return attrString;
}

void makeCommentwithPost(UILabel *comment, Post *post) {
    if (post.author.username && post.caption) {
        NSMutableAttributedString *attrString = makeStringwithAppend(post.author.username, post.caption);
        [comment setAttributedText: attrString];
    } else {
        comment.text = post.caption;
    }
}

#pragma mark - Tap Gesture Recognizer helper

void setupGRonImagewithTaps(UITapGestureRecognizer *tgr, UIImageView *imageView, int numTaps) {
    tgr.numberOfTapsRequired = (NSInteger) numTaps;
    [imageView addGestureRecognizer:tgr];
    [imageView setUserInteractionEnabled:YES];
}

#pragma mark - Image setting helper functions

void makeProfileImagewithUser(UIImageView *profilePicture, PFUser *user) {
    PFFileObject *image = [user objectForKey:@"image"];
    if (image) {
        [image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!data) {
                return NSLog(@"%@", error);
            }
            profilePicture.image = [UIImage imageWithData:data];
        }];
    } else {
        profilePicture.image = [UIImage imageNamed:@"profile-icon"];
    }
    profilePicture.layer.cornerRadius = profilePicture.frame.size.width / 2;
    profilePicture.clipsToBounds = YES;
}

void makePostforImage(UIImageView *postImage, PFFileObject *postFile) {
    [postFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!data) {
            return NSLog(@"%@", error);
        }
        postImage.image = [UIImage imageWithData:data];
    }];
}

#pragma mark - Button setting helper functions

void initialButtonSettingforPost(UIButton *likeButton, Post *post) {
    PFUser *currUser = [PFUser currentUser];
    NSMutableArray *likedUsers = [post objectForKey:@"likedUsers"];
    if ([likedUsers containsObject:currUser.username]) {
        [likeButton setImage: [UIImage imageNamed:@"redLikeButton"] forState:UIControlStateNormal];
    } else {
        [likeButton setImage: [UIImage imageNamed:@"likeButton"] forState:UIControlStateNormal];
    }
}

int doLikeActionforPostallowUnlike(UIButton *likeButton, Post *post, BOOL allow) {
    int incrChange = 0;
    PFUser *currUser = [PFUser currentUser];
    NSMutableArray *likedUsers = [post objectForKey:@"likedUsers"];
    if (!likedUsers) {
        likedUsers = [[NSMutableArray alloc] init];
    }
    if ([likedUsers containsObject:currUser.username]) {
        if (allow) {
            [likedUsers removeObject:currUser.username];
            incrChange = -1;
            [likeButton setImage: [UIImage imageNamed:@"likeButton"] forState:UIControlStateNormal];
        }
    } else {
        [likedUsers addObject:currUser.username];
        incrChange = 1;
        [likeButton setImage: [UIImage imageNamed:@"redLikeButton"] forState:UIControlStateNormal];
    }
    [post setObject:likedUsers forKey:@"likedUsers"];
    [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
        }
    }];
    return incrChange;
}

void makeImagePicker(UIViewController *vc) {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = vc;
    imagePickerVC.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [vc presentViewController:imagePickerVC animated:YES completion:nil];
}

@implementation InstagramHelper

@end
