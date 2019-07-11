//
//  InstagramHelper.m
//  Instagram
//
//  Created by aliu18 on 7/9/19.
//  Copyright © 2019 aliu18. All rights reserved.
//

#import "InstagramHelper.h"
#import <UIKit/UIKit.h>

/*
void instantiateGestureRecognizer(UIImageView *postImage) {
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doDoubleTap)];
    doubleTap.numberOfTapsRequired = (NSInteger) 2;
    [self.postImage addGestureRecognizer:doubleTap];
    [self.postImage setUserInteractionEnabled:YES];
}

*/
@implementation InstagramHelper

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

+ (void) setupGR: (UITapGestureRecognizer *) tgr onImage: (UIImageView *) imageView withTaps: (int) numTaps {
    tgr.numberOfTapsRequired = (NSInteger) numTaps;
    [imageView addGestureRecognizer:tgr];
    [imageView setUserInteractionEnabled:YES];
}




- (NSMutableAttributedString *) makeString: (NSString *) username withAppend: (NSString *) caption {
    NSString *frontAddSpace = [username stringByAppendingString:@" "];
    NSString *fullText = [frontAddSpace stringByAppendingString:caption];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:fullText];
    NSRange boldRange = [fullText rangeOfString:username];
    [attrString addAttribute: NSFontAttributeName value:[UIFont boldSystemFontOfSize:18] range:boldRange];
    return attrString;
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
