//
//  PostDetailsViewController.m
//  Instagram
//
//  Created by aliu18 on 7/9/19.
//  Copyright © 2019 aliu18. All rights reserved.
//

#import "PostDetailsViewController.h"

@interface PostDetailsViewController () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *caption;
@property (weak, nonatomic) IBOutlet UILabel *likeCount;
@property (weak, nonatomic) IBOutlet UIImageView *likeImage;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (nonatomic) BOOL doubleTapLike;
@property (nonatomic) long likeCountNum;

@end

#pragma mark - C helper methods

static void makePostImage(PFFileObject *postFile, UIImageView *postImage) {
    //UIImage *image = [[UIImage alloc] init];
    [postFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!data) {
            return NSLog(@"%@", error);
        }
        postImage.image = [UIImage imageWithData:data];
    }];
}

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

@implementation PostDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.username.text = self.post.author.username;
    self.dateLabel.text = formatDate(self.post.createdAt);
    self.caption.text = self.post.caption;
    self.likeCountNum = [self makeLikeCount];
    self.likeCount.text = [self makeString: self.likeCountNum];
    
    //[self makePostImage:self.post.image];
    makePostImage(self.post.image, self.postImage);
    [self instantiateGestureRecognizer];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    PFUser *currUser = [PFUser currentUser];
    NSMutableArray *likedUsers = [self.post objectForKey:@"likedUsers"];
    if ([likedUsers containsObject:currUser.username]) {
        [self.likeButton setImage: [UIImage imageNamed:@"redLikButton"] forState:UIControlStateNormal];
    }
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
- (IBAction)didTapLike:(id)sender {
    PFUser *currUser = [PFUser currentUser];
    NSMutableArray *likedUsers = [self.post objectForKey:@"likedUsers"];
    if (!likedUsers) {
        likedUsers = [[NSMutableArray alloc] init];
    }
    if ([likedUsers containsObject:currUser.username]) {
        if (!self.doubleTapLike) {
            [likedUsers removeObject:currUser.username];
            self.likeCount.text = [self incrLikeCount: -1];
            [self.post setObject:likedUsers forKey:@"likedUsers"];
            [self.likeButton setImage: [UIImage imageNamed:@"likeButton"] forState:UIControlStateNormal];
        }
        self.doubleTapLike = NO;
    } else {
        /*NSNumber *prevCount = [self.post objectForKey:@"likeCount"];
         NSNumber *newCount = [self increaseCount:prevCount by:1];
         [self.post setObject:newCount forKey:@"likeCount"];*/
        [likedUsers addObject:currUser.username];
        self.likeCount.text = [self incrLikeCount: 1];
        [self.post setObject:likedUsers forKey:@"likedUsers"];
        [self.likeButton setImage: [UIImage imageNamed:@"redLikeButton"] forState:UIControlStateNormal];
    }
    [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
        }
    }];
}

- (void) fadeOut {
    [UIView animateWithDuration:1 animations:^{
        self.likeImage.alpha = 0.0;
    }];
}

-(void) doSingleTap {
    //[self performSegueWithIdentifier:@"homeFeedSegue" sender:nil];
}

- (NSString *) incrLikeCount: (int) incr {
    self.likeCountNum += incr;
    return [self makeString: self.likeCountNum];
}

- (long) makeLikeCount {
    //NSNumber *numLikes = [self.post objectForKey:@"likeCount"];
    NSArray *likedUsers = [self.post objectForKey:@"likedUsers"];
    long count = likedUsers.count;
    return count;
}

- (NSString *) makeString: (long) count {
    NSString *numLikeString = [@(count) stringValue];
    NSString *likeString = [NSString stringWithFormat:@"%@ likes", numLikeString];
    return likeString;
}

#pragma mark - PostDetailsViewController helper function
/*
-(NSString *) formatDate: (NSDate *) createdAtOriginalString {
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
}*/

-(void) makePostImage: (PFFileObject *) postFile {
    //UIImage *image = [[UIImage alloc] init];
    [postFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!data) {
            return NSLog(@"%@", error);
        }
        self.postImage.image = [UIImage imageWithData:data];
    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
