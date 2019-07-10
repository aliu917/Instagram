//
//  PostCell.m
//  Instagram
//
//  Created by aliu18 on 7/8/19.
//  Copyright © 2019 aliu18. All rights reserved.
//

#import "PostCell.h"
#import "Post.h"

@implementation PostCell

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

#pragma mark - PostCell lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void) setPost: (Post *) post {
    NSLog(@"setPost called");
    _post = post;
    self.username.text = post.author.username;
    if (post.author.username && post.caption) {
        self.comment.text = [post.author.username stringByAppendingString: post.caption];
    } else {
        self.comment.text = post.caption;
    }
    self.dateLabel.text = formatDate(self.post.createdAt);
    [self makePostImage: post.image];
    
    
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
    
    
    //self.profilePicture.image = [post.author objectForKey:@"image"];
    //self.postImage.image = post.image;
}

- (IBAction)didTapLike:(id)sender {
    if (self.favorited) {
        self.favoriteCount -= 1;
    } else {
        self.favoriteCount += 1;
    }
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
