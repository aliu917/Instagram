//
//  PostCell.m
//  Instagram
//
//  Created by aliu18 on 7/8/19.
//  Copyright © 2019 aliu18. All rights reserved.
//

#import "PostCell.h"
#import "Post.h"
#import "InstagramHelper.h"

@implementation PostCell

#pragma mark - PostCell lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    [self instantiateGestureRecognizer];
}

- (void) setPost: (Post *) post {
    _post = post;
    self.username.text = post.author.username;
    makeCommentwithPost(self.comment, post);
    self.dateLabel.text = formatDate(self.post.createdAt);
    makePostforImage(self.postImage, post.image);
    makeProfileImagewithUser(self.profilePicture, post.author);
}

#pragma mark - Action: tapped comment tab to segue

- (IBAction)segueToDetails:(id)sender {
    [self.delegate performSegue:@"detailsSegue" didTap:self.post];
}
- (IBAction)segueToComment:(id)sender {
    [self.delegate performSegue:@"commentSegue" didTap:self.post];
}

- (IBAction)didTapLike:(id)usedButton {
    doLikeActionforPostallowUnlike(self.likeButton, self.post, YES);
}

#pragma mark - PostCell Gesture Recognizer helper functions

- (void) instantiateGestureRecognizer {
    UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUserProfile:)];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doDoubleTap)];
    setupGRonImagewithTaps(profileTapGestureRecognizer, self.profilePicture, 1);
    setupGRonImagewithTaps(doubleTap, self.postImage, 2);
}

- (void) doDoubleTap {
    [UIView animateWithDuration:1 animations:^{
        self.likeImage.alpha = 0.75;
    }];
    [self performSelector:@selector(fadeOut) withObject:self.likeImage afterDelay:1.0];
    doLikeActionforPostallowUnlike(self.likeButton, self.post, NO);
}

- (void) fadeOut {
    [UIView animateWithDuration:1 animations:^{
        self.likeImage.alpha = 0.0;
    }];
}

- (void) didTapUserProfile:(UITapGestureRecognizer *)sender{
    [self.delegate performSegue:@"profileSegue" didTap:self.post.author];
}

@end
