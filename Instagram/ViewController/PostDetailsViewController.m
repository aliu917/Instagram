//
//  PostDetailsViewController.m
//  Instagram
//
//  Created by aliu18 on 7/9/19.
//  Copyright © 2019 aliu18. All rights reserved.
//

#import "PostDetailsViewController.h"
#import "InstagramHelper.h"

@interface PostDetailsViewController () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *caption;
@property (weak, nonatomic) IBOutlet UILabel *likeCount;
@property (weak, nonatomic) IBOutlet UIImageView *likeImage;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (nonatomic) BOOL doubleTapLike;
@property (nonatomic) long likeCountNum;

@end

static NSString* makeString(long count) {
    NSString *numLikeString = [@(count) stringValue];
    NSString *likeString = [NSString stringWithFormat:@"%@ likes", numLikeString];
    return likeString;
}

static long makeLikeCount(Post *post) {
    //NSArray *likedUsers = [post objectForKey:@"likedUsers"];
    NSDictionary *likedUsersDict = [post objectForKey:@"likedUsersDict"];
    long count = [likedUsersDict count];
    //long count = likedUsers.count;
    return count;
}


@implementation PostDetailsViewController

#pragma mark - PostDetailsViewController lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dateLabel.text = [InstagramHelper formatDate: self.post.createdAt];
    [InstagramHelper makeComment:self.caption withPost:self.post];
    self.likeCountNum = makeLikeCount(self.post);
    self.likeCount.text = makeString(self.likeCountNum);
    [InstagramHelper makePost: self.postImage forImage: self.post.image];
    [self instantiateGestureRecognizer];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [InstagramHelper initialButtonSetting: self.likeButton forPost: self.post];
}

#pragma mark - Action: like posts

- (IBAction)didTapLike:(id)sender {
    int change = [InstagramHelper doLikeAction: self.likeButton forPost: self.post allowUnlike: YES];
    self.likeCount.text = [self incrLikeCount:change];
}

#pragma mark - Gesture Recognizer helper functions

- (void) instantiateGestureRecognizer {
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doDoubleTap)];
    [InstagramHelper setupGR: doubleTap onImage: self.postImage withTaps: 2];
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

- (NSString *) incrLikeCount: (int) incr {
    self.likeCountNum += incr;
    return makeString(self.likeCountNum);
}
/*
- (long) makeLikeCount: (Post *) post {
    //NSNumber *numLikes = [self.post objectForKey:@"likeCount"];
    NSArray *likedUsers = [post objectForKey:@"likedUsers"];
    long count = likedUsers.count;
    return count;
}*/
/*
- (NSString *) makeString: (long) count {
    NSString *numLikeString = [@(count) stringValue];
    NSString *likeString = [NSString stringWithFormat:@"%@ likes", numLikeString];
    return likeString;
}
*/
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
/*
-(void) makePostImage: (PFFileObject *) postFile {
    //UIImage *image = [[UIImage alloc] init];
    [postFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!data) {
            return NSLog(@"%@", error);
        }
        self.postImage.image = [UIImage imageWithData:data];
    }];
}*/


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
