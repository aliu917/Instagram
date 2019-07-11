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

/*
static void makeCommentwithPost(UILabel *comment, Post *post) {
    if (post.author.username && post.caption) {
        NSMutableAttributedString *attrString = [InstagramHelper makeString:post.author.username withAppend: post.caption];
        [comment setAttributedText: attrString];
    } else {
        comment.text = post.caption;
    }
}*/

@implementation PostCell

#pragma mark - PostCell lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    [self instantiateGestureRecognizer];
}

- (void) setPost: (Post *) post {
    NSLog(@"setPost called");
    _post = post;
    self.username.text = post.author.username;
    [InstagramHelper makeComment:self.comment withPost: post];
    self.dateLabel.text = [InstagramHelper formatDate:self.post.createdAt];
    [InstagramHelper makePost: self.postImage forImage: post.image];
    [InstagramHelper makeProfileImage: self.profilePicture withUser: post.author];
    [InstagramHelper initialButtonSetting: self.likeButton forPost: self.post];
}

#pragma mark - Action: tapped comment tab to segue

- (IBAction)segueToDetails:(id)sender {
    [self.delegate performSegue:@"detailsSegue" didTap:self.post];
}

- (IBAction)didTapLike:(id)usedButton {
    [InstagramHelper doLikeAction: self.likeButton forPost: self.post allowUnlike: YES];
}

#pragma mark - PostCell Gesture Recognizer helper functions

- (void) instantiateGestureRecognizer {
    UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUserProfile:)];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doDoubleTap)];
    
    [InstagramHelper setupGR:profileTapGestureRecognizer onImage:self.profilePicture withTaps:1];
    [InstagramHelper setupGR:doubleTap onImage:self.postImage withTaps:2];
}

- (void) doDoubleTap {
    [UIView animateWithDuration:1 animations:^{
        self.likeImage.alpha = 0.75;
    }];
    [self performSelector:@selector(fadeOut) withObject:self.likeImage afterDelay:1.0];
    [InstagramHelper doLikeAction: self.likeButton forPost: self.post allowUnlike: NO];
}

- (void) fadeOut {
    [UIView animateWithDuration:1 animations:^{
        self.likeImage.alpha = 0.0;
    }];
}

- (void) didTapUserProfile:(UITapGestureRecognizer *)sender{
    [self.delegate performSegue:@"profileSegue" didTap:self.post.author];
}

/*
-(void) doLikeAction: (UIButton *) likeButton forPost: (Post *) post allowUnlike: (BOOL) allow{
    PFUser *currUser = [PFUser currentUser];
    NSMutableArray *likedUsers = [post objectForKey:@"likedUsers"];
    if (!likedUsers) {
        likedUsers = [[NSMutableArray alloc] init];
    }
    if ([likedUsers containsObject:currUser.username]) {
        if (allow) {
            [likedUsers removeObject:currUser.username];
            [post setObject:likedUsers forKey:@"likedUsers"];
            [likeButton setImage: [UIImage imageNamed:@"likeButton"] forState:UIControlStateNormal];
        }
    } else {
        [likedUsers addObject:currUser.username];
        [post setObject:likedUsers forKey:@"likedUsers"];
        [likeButton setImage: [UIImage imageNamed:@"redLikeButton"] forState:UIControlStateNormal];
    }
    [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
        }
    }];
}
*/

/*
- (NSNumber *) increaseCount: (NSNumber *) number by: (int) increment {
    NSNumber *newNumber = @(number.longLongValue + increment);
    return newNumber;
}
*/
/*
 - (void) setupGR: (UITapGestureRecognizer *) tgr onImage: (UIImageView *) imageView withTaps: (int) numTaps {
 tgr.numberOfTapsRequired = (NSInteger) numTaps;
 [imageView addGestureRecognizer:tgr];
 [imageView setUserInteractionEnabled:YES];
 }
 */

/*
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
*/
/*
- (NSMutableAttributedString *) makeString: (NSString *) username withAppend: (NSString *) caption {
    NSString *frontAddSpace = [username stringByAppendingString:@" "];
    NSString *fullText = [frontAddSpace stringByAppendingString:caption];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:fullText];
    NSRange boldRange = [fullText rangeOfString:username];
    [attrString addAttribute: NSFontAttributeName value:[UIFont boldSystemFontOfSize:18] range:boldRange];
    return attrString;
}*/
/*
-(void) makePostImage: (PFFileObject *) postFile {
    [postFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!data) {
            return NSLog(@"%@", error);
        }
        self.postImage.image = [UIImage imageWithData:data];
    }];
}
*/

/*
 -(void) initialButtonSetting: (UIButton *)likeButton forPost: (Post *)post {
 PFUser *currUser = [PFUser currentUser];
 NSMutableArray *likedUsers = [post objectForKey:@"likedUsers"];
 if ([likedUsers containsObject:currUser.username]) {
 [likeButton setImage: [UIImage imageNamed:@"redLikButton"] forState:UIControlStateNormal];
 }
 }*/


/*
 - (void) makeComment: (UILabel *) comment withPost: (Post *) post {
 if (post.author.username && post.caption) {
 NSMutableAttributedString *attrString = [InstagramHelper makeString:post.author.username withAppend: post.caption];
 [comment setAttributedText: attrString];
 } else {
 comment.text = post.caption;
 }
 }
 */

/*
 -(void) makeProfileImage: (UIImageView *) profilePicture withPost: (Post *) post {
 PFFileObject *image = [post.author objectForKey:@"image"];
 
 //FIX LATER
 if (image) {
 [image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
 if (!data) {
 return NSLog(@"%@", error);
 }
 profilePicture.image = [UIImage imageWithData:data];
 }];
 }
 profilePicture.layer.cornerRadius = profilePicture.frame.size.width / 2;
 profilePicture.clipsToBounds = YES;
 }*/

@end
