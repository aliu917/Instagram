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

//NSString * formatDate(NSDate *createdAtOriginalString);
+ (NSString *) formatDate: (NSDate *)createdAtOriginalString;
+ (void) setupGR: (UITapGestureRecognizer *) tgr onImage: (UIImageView *) imageView withTaps: (int) numTaps;
+(void) makeProfileImage: (UIImageView *) profilePicture withPost: (Post *) post;
+ (NSMutableAttributedString *) makeString: (NSString *) username withAppend: (NSString *) caption;
+(void) makePost: (UIImageView *) postImage forImage: (PFFileObject *) postFile;
+(void) initialButtonSetting: (UIButton *)likeButton forPost: (Post *)post;
+ (void) makeComment:(UILabel *)comment withPost:(Post *) post;
+(void) doLikeAction: (UIButton *) likeButton forPost: (Post *) post allowUnlike: (BOOL) allow;



@end

NS_ASSUME_NONNULL_END
