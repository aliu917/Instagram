//
//  InstagramHelper.h
//  Instagram
//
//  Created by aliu18 on 7/9/19.
//  Copyright © 2019 aliu18. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface InstagramHelper : NSObject

NSString * formatDate(NSDate *createdAtOriginalString);
NSMutableAttributedString* makeStringwithAppend(NSString *username, NSString *caption);
void makeCommentwithPost(UILabel *comment, Post *post);
void setupGRonImagewithTaps(UITapGestureRecognizer *tgr, UIImageView *imageView, int numTaps);
void makeProfileImagewithUser(UIImageView *profilePicture, PFUser *user);
void makePostforImage(UIImageView *postImage, PFFileObject *postFile);
void initialButtonSettingforPost(UIButton *likeButton, Post *post);
int doLikeActionforPostallowUnlike(UIButton *likeButton, Post *post, BOOL allow);
void makeImagePicker(UIViewController *vc);

@end

NS_ASSUME_NONNULL_END
