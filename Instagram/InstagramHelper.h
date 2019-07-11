//
//  InstagramHelper.h
//  Instagram
//
//  Created by aliu18 on 7/9/19.
//  Copyright © 2019 aliu18. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InstagramHelper : NSObject

//NSString * formatDate(NSDate *createdAtOriginalString);
+ (NSString *) formatDate: (NSDate *)createdAtOriginalString;
+ (void) setupGR: (UITapGestureRecognizer *) tgr onImage: (UIImageView *) imageView withTaps: (int) numTaps;


@end

NS_ASSUME_NONNULL_END
