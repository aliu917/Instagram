//
//  PostDetailsViewController.m
//  Instagram
//
//  Created by aliu18 on 7/9/19.
//  Copyright © 2019 aliu18. All rights reserved.
//

#import "PostDetailsViewController.h"
#import "InstagramHelper.h"
#import "LikeDetailsViewController.h"
#import "CommentViewController.h"

@interface PostDetailsViewController () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *caption;
@property (weak, nonatomic) IBOutlet UIImageView *likeImage;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (nonatomic) BOOL doubleTapLike;
@property (nonatomic) long likeCountNum;
@property (weak, nonatomic) IBOutlet UIButton *likeCount;
@property (weak, nonatomic) IBOutlet UIButton *commentCount;

@end

static NSString* makeString(long count, NSString *string) {
    if (count == 1) {
        string = [string substringToIndex:[string length]-1];
    }
    NSString *numString = [@(count) stringValue];
    NSString *prevString = [NSString stringWithFormat:@"%@ ", numString];
    NSString *finalString = [prevString stringByAppendingString: string];
    return finalString;
}

static long makeLikeCount(Post *post) {
    NSArray *likedUsers = [post objectForKey:@"likedUsers"];
    long count = likedUsers.count;
    return count;
}

static void makeCommentButtons(Post *post, UIButton *commentCount) {
    NSArray *comments = [post objectForKey:@"commentsArray"];
    long count = [comments count];
    NSString *commentText = makeString(count, @"comments");
    [commentCount setTitle:commentText forState:UIControlStateNormal];
}

@implementation PostDetailsViewController

#pragma mark - PostDetailsViewController lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dateLabel.text = formatDate (self.post.createdAt);
    makeCommentwithPost(self.caption, self.post);
    self.likeCountNum = makeLikeCount(self.post);
    NSString *likeCountText = makeString(self.likeCountNum, @"likes");
    [self.likeCount setTitle:likeCountText forState:UIControlStateNormal];
    makeCommentButtons(self.post, self.commentCount);
    makePostforImage(self.postImage, self.post.image);
    [self instantiateGestureRecognizer];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    initialButtonSettingforPost(self.likeButton, self.post);
    makeCommentButtons(self.post, self.commentCount);
}

#pragma mark - Action: like posts

- (IBAction)didTapLike:(id)sender {
    int change = doLikeActionforPostallowUnlike(self.likeButton, self.post, sender != nil);
    NSString *likeCountText = [self incrCount:change withUnit: @"likes"];
    [self.likeCount setTitle:likeCountText forState:UIControlStateNormal];
}

#pragma mark - Gesture Recognizer helper functions

- (void) instantiateGestureRecognizer {
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doDoubleTap)];
    setupGRonImagewithTaps(doubleTap, self.postImage, 2);
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

- (NSString *) incrCount: (int) incr withUnit: (NSString *) string {
    self.likeCountNum += incr;
    return makeString(self.likeCountNum, string);
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"commentDetailsSegue"]) {
        NSArray *array = [self.post objectForKey:@"commentsArray"];
        LikeDetailsViewController *likeDetailsViewController = [segue destinationViewController];
        likeDetailsViewController.array = array;
        likeDetailsViewController.units = @"commented";
    } else if ([segue.identifier isEqualToString:@"composeFromDetailsSegue"]) {
        CommentViewController *commentViewController = [segue destinationViewController];
        commentViewController.post = self.post;
    } else {
        NSArray *array = [self.post objectForKey:@"likedUsers"];
        LikeDetailsViewController *likeDetailsViewController = [segue destinationViewController];
        likeDetailsViewController.array = array;
        likeDetailsViewController.units = @"liked";
    }
}


@end
