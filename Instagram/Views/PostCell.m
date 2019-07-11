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
    UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUserProfile:)];
    [self.profilePicture addGestureRecognizer:profileTapGestureRecognizer];
    [self.profilePicture setUserInteractionEnabled:YES];
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

- (void) didTapUserProfile:(UITapGestureRecognizer *)sender{
    [self.delegate postCell:self didTap:self.post.author];
}



/*
- (void) instantiateGesureRecognizer {
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doSingleTap)];
    singleTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doDoubleTap)];
    doubleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTap];
    
}
*/
- (void) doDoubleTap {
    
}

-(void) doSingleTap {
    //[self performSegueWithIdentifier:@"homeFeedSegue" sender:nil];
}

- (IBAction)didTapLike:(id)sender {
    PFUser *currUser = [PFUser currentUser];
    if (self.favorited) {
        self.favorited = false;
        self.favoriteCount -= 1;
        /*NSNumber
        *prevCount = [self.post objectForKey:@"likeCount"];
        NSNumber *newCount = [self increaseCount:prevCount by:-1];
        [self.post setObject:newCount forKey:@"likeCount"];*/
        NSMutableArray *likedUsers = [self.post objectForKey:@"likedUsers"];
        [likedUsers removeObject:currUser];
        [self.post setObject:likedUsers forKey:@"likedUsers"];
        [self.likeButton setImage: [UIImage imageNamed:@"favor-icon-1"] forState:UIControlStateNormal];
    } else {
        self.favorited = true;
        self.favoriteCount += 1;
        /*NSNumber *prevCount = [self.post objectForKey:@"likeCount"];
        NSNumber *newCount = [self increaseCount:prevCount by:1];
        [self.post setObject:newCount forKey:@"likeCount"];*/
        NSMutableArray *likedUsers = [self.post objectForKey:@"likedUsers"];
        if (!likedUsers) {
            likedUsers = [[NSMutableArray alloc] init];
        }
        [likedUsers addObject:currUser];
        [self.post setObject:likedUsers forKey:@"likedUsers"];
        [self.likeButton setImage: [UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
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
