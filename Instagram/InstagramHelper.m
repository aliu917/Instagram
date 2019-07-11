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

/*
void instantiateGestureRecognizer(UIImageView *postImage) {
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doDoubleTap)];
    doubleTap.numberOfTapsRequired = (NSInteger) 2;
    [self.postImage addGestureRecognizer:doubleTap];
    [self.postImage setUserInteractionEnabled:YES];
}

*/
@implementation InstagramHelper

#pragma mark - String formatting helpers

+ (NSString *) formatDate: (NSDate *)createdAtOriginalString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDate *todayDate = [NSDate date];
    double ti = [createdAtOriginalString timeIntervalSinceDate:todayDate];
    ti = ti * -1;
    if(ti < 1) {
        return @"never";
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

+ (NSMutableAttributedString *) makeString: (NSString *) username withAppend: (NSString *) caption {
    NSString *frontAddSpace = [username stringByAppendingString:@" "];
    NSString *fullText = [frontAddSpace stringByAppendingString:caption];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:fullText];
    NSRange boldRange = [fullText rangeOfString:username];
    [attrString addAttribute: NSFontAttributeName value:[UIFont boldSystemFontOfSize:20] range:boldRange];
    return attrString;
}

+ (void) makeComment:(UILabel *)comment withPost:(Post *) post {
    if (post.author.username && post.caption) {
        NSMutableAttributedString *attrString = [InstagramHelper makeString:post.author.username withAppend: post.caption];
        [comment setAttributedText: attrString];
    } else {
        comment.text = post.caption;
    }
}

#pragma mark - Tap Gesture Recognizer helper

+ (void) setupGR: (UITapGestureRecognizer *) tgr onImage: (UIImageView *) imageView withTaps: (int) numTaps {
    tgr.numberOfTapsRequired = (NSInteger) numTaps;
    [imageView addGestureRecognizer:tgr];
    [imageView setUserInteractionEnabled:YES];
}

#pragma mark - Image setting helper functions

+(void) makeProfileImage: (UIImageView *) profilePicture withUser: (PFUser *) user {
    PFFileObject *image = [user objectForKey:@"image"];
    
    //FIX LATER
    if (image) {
        [image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!data) {
                return NSLog(@"%@", error);
            }
            profilePicture.image = [UIImage imageWithData:data];
        }];
    }
    profilePicture.layer.cornerRadius = profilePicture.frame.size.width / 2;
    profilePicture.clipsToBounds = YES;
}

+(void) makePost: (UIImageView *) postImage forImage: (PFFileObject *) postFile {
    [postFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!data) {
            return NSLog(@"%@", error);
        }
        postImage.image = [UIImage imageWithData:data];
    }];
}

#pragma mark - Button setting helper functions

+(void) initialButtonSetting: (UIButton *)likeButton forPost: (Post *)post {
    PFUser *currUser = [PFUser currentUser];
    NSMutableArray *likedUsers = [post objectForKey:@"likedUsers"];
    //NSMutableDictionary *likedUsersDict = [post objectForKey:@"likedUsersDict"];
    //NSDictionary *tempDict = likedUsersDict;
    if ([likedUsers containsObject:currUser.username]) {
    //if ([likedUsersDict objectForKey:currUser.username]) {
        [likeButton setImage: [UIImage imageNamed:@"redLikeButton"] forState:UIControlStateNormal];
    }
}

+(int) doLikeAction: (UIButton *) likeButton forPost: (Post *) post allowUnlike: (BOOL) allow {
    int incrChange = 0;
    PFUser *currUser = [PFUser currentUser];
    NSMutableArray *likedUsers = [post objectForKey:@"likedUsers"];
    //NSMutableDictionary *likedUsersDict = [post objectForKey:@"likedUsersDict"];
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
    /*if (!likedUsersDict) {
        likedUsersDict = [[NSMutableDictionary alloc] init];
    }
    if ([likedUsersDict objectForKey:currUser.username]) {
        if (allow) {
            [likedUsersDict removeObjectForKey:currUser.username];
            incrChange = -1;
            [likeButton setImage: [UIImage imageNamed:@"likeButton"] forState:UIControlStateNormal];
        }
    } else {
        [likedUsersDict setObject: currUser forKey: currUser.username];
        incrChange = 1;
        [likeButton setImage: [UIImage imageNamed:@"redLikeButton"] forState:UIControlStateNormal];
    }
    [post setObject:likedUsersDict forKey:@"likedUsersDict"];
    NSDictionary *temp = [post objectForKey:@"likedUsersDict"];*/
    [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
        }
    }];
    return incrChange;
}

+ (void) makeImagePicker: (UIViewController *) vc {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = vc;
    imagePickerVC.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [vc presentViewController:imagePickerVC animated:YES completion:nil];
}

/*
NSString * formatDate(NSDate *createdAtOriginalString) {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //[formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    //[formatter setDateFormat:@"E MMM d HH:mm:ss Z y"];
    NSDate *todayDate = [NSDate date];
    double ti = [createdAtOriginalString timeIntervalSinceDate:todayDate];
    ti = ti * -1;
    if(ti < 1) {
        return @"never";
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
*/
/*
void instantiateGestureRecognizer(UIImageView *postImage) {
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doDoubleTap)];
    doubleTap.numberOfTapsRequired = (NSInteger) 2;
    [postImage addGestureRecognizer:doubleTap];
    [postImage setUserInteractionEnabled:YES];
    //[doubleTap release];
}*/
/*
-(void) changeLikeButton:(UIButton *) likeButton onlyLike: (BOOL) onlyLike {
    
}*/

@end
