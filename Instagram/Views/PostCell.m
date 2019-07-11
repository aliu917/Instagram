//
//  PostCell.m
//  Instagram
//
//  Created by aliu18 on 7/8/19.
//  Copyright © 2019 aliu18. All rights reserved.
//

#import "PostCell.h"
#import "Post.h"

static NSString * formatDate(NSDate *createdAtOriginalString) {
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

@implementation PostCell

#pragma mark - PostCell lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUserProfile:)];
    [self.profilePicture addGestureRecognizer:profileTapGestureRecognizer];
    [self.profilePicture setUserInteractionEnabled:YES];
    /*
    PFUser *currUser = [PFUser currentUser];
    NSMutableArray *likedUsers = [self.post objectForKey:@"likedUsers"];
    if ([likedUsers containsObject:currUser.username]) {
        [self.likeButton setImage: [UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
    }*/

}

- (void) setPost: (Post *) post {
    NSLog(@"setPost called");
    _post = post;
    self.username.text = post.author.username;
    if (post.author.username && post.caption) {
        NSMutableAttributedString *attrString = [self makeString:post.author.username withAppend: post.caption];
        [self.comment setAttributedText: attrString];

    } else {
        self.comment.text = post.caption;
    }
    self.dateLabel.text = formatDate(self.post.createdAt);
    [self makePostImage: post.image];
    [self instantiateGestureRecognizer];

    
    //Fix later
    
    PFFileObject *image = [post.author objectForKey:@"image"];
    
    //FIX LATER
    if (image) {
        [image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!data) {
                return NSLog(@"%@", error);
            }
            self.profilePicture.image = [UIImage imageWithData:data];
        }];
    }
    
    
    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width / 2;
    self.profilePicture.clipsToBounds = YES;
    
    
    PFUser *currUser = [PFUser currentUser];
    NSMutableArray *likedUsers = [self.post objectForKey:@"likedUsers"];
    if ([likedUsers containsObject:currUser.username]) {
        [self.likeButton setImage: [UIImage imageNamed:@"redLikButton"] forState:UIControlStateNormal];
    }
    
    
    //self.profilePicture.image = [post.author objectForKey:@"image"];
    //self.postImage.image = post.image;
}

- (NSMutableAttributedString *) makeString: (NSString *) username withAppend: (NSString *) caption {
    NSString *frontAddSpace = [username stringByAppendingString:@" "];
    NSString *fullText = [frontAddSpace stringByAppendingString:caption];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:fullText];
    NSRange boldRange = [fullText rangeOfString:username];
    [attrString addAttribute: NSFontAttributeName value:[UIFont boldSystemFontOfSize:18] range:boldRange];
    return attrString;
}


- (void) instantiateGestureRecognizer {
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doDoubleTap)];
    doubleTap.numberOfTapsRequired = (NSInteger) 2;
    [self.postImage addGestureRecognizer:doubleTap];
    [self.postImage setUserInteractionEnabled:YES];

}

- (void) doDoubleTap {
    self.likeImage.layer.cornerRadius = self.likeImage.frame.size.width / 2;
    self.likeImage.clipsToBounds = YES;
    [UIView animateWithDuration:1 animations:^{
        self.likeImage.alpha = 0.75;
    }];
    [self performSelector:@selector(fadeOut) withObject:self.likeImage afterDelay:1.0];
    self.doubleTapLike = YES;
    [self didTapLike: nil];
    
}

- (void) fadeOut {
    [UIView animateWithDuration:1 animations:^{
        self.likeImage.alpha = 0.0;
    }];
}

- (void) didTapUserProfile:(UITapGestureRecognizer *)sender{
    [self.delegate postCell:self didTap:self.post.author];
}


- (IBAction)didTapLike:(id)sender {
    PFUser *currUser = [PFUser currentUser];
    NSMutableArray *likedUsers = [self.post objectForKey:@"likedUsers"];
    if (!likedUsers) {
        likedUsers = [[NSMutableArray alloc] init];
    }
    if ([likedUsers containsObject:currUser.username]) {
        if (!self.doubleTapLike) {
            [likedUsers removeObject:currUser.username];
            [self.post setObject:likedUsers forKey:@"likedUsers"];
            [self.likeButton setImage: [UIImage imageNamed:@"likeButton"] forState:UIControlStateNormal];
        }
        self.doubleTapLike = NO;
    } else {
        /*NSNumber *prevCount = [self.post objectForKey:@"likeCount"];
        NSNumber *newCount = [self increaseCount:prevCount by:1];
        [self.post setObject:newCount forKey:@"likeCount"];*/
        [likedUsers addObject:currUser.username];
        [self.post setObject:likedUsers forKey:@"likedUsers"];
        [self.likeButton setImage: [UIImage imageNamed:@"redLikeButton"] forState:UIControlStateNormal];
    }
    [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
        }
    }];
}

- (NSNumber *) increaseCount: (NSNumber *) number by: (int) increment {
    NSNumber *newNumber = @(number.longLongValue + increment);
    return newNumber;
}

/*
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
*/

-(void) makePostImage: (PFFileObject *) postFile {
    [postFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!data) {
            return NSLog(@"%@", error);
        }
        self.postImage.image = [UIImage imageWithData:data];
    }];
}


@end
