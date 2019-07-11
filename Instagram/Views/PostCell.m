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

    //UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUserProfile:)];
    //[self.profilePicture addGestureRecognizer:profileTapGestureRecognizer];
    //[self.profilePicture setUserInteractionEnabled:YES];
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
    //self.dateLabel.text = formatDate(self.post.createdAt);
    self.dateLabel.text = [InstagramHelper formatDate:self.post.createdAt];
    [self makePostImage: post.image];
    
    
    
    
    
    
    
    
    
    
    
    
    //[self instantiateGestureRecognizer];

    
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

- (IBAction)segueToDetails:(id)sender {
    [self.delegate performSegue:@"detailsSegue" didTap:self.post];
}


- (void) instantiateGestureRecognizer {
    UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUserProfile:)];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doDoubleTap)];
    
    [InstagramHelper setupGR:profileTapGestureRecognizer onImage:self.profilePicture withTaps:1];
    [InstagramHelper setupGR:doubleTap onImage:self.postImage withTaps:2];
    /*
    [self.profilePicture addGestureRecognizer:profileTapGestureRecognizer];
    [self.profilePicture setUserInteractionEnabled:YES];
    
    
    
    
    doubleTap.numberOfTapsRequired = (NSInteger) 2;
    [self.postImage addGestureRecognizer:doubleTap];
    [self.postImage setUserInteractionEnabled:YES];*/

}
/*
- (void) setupGR: (UITapGestureRecognizer *) tgr onImage: (UIImageView *) imageView withTaps: (int) numTaps {
    tgr.numberOfTapsRequired = (NSInteger) numTaps;
    [imageView addGestureRecognizer:tgr];
    [imageView setUserInteractionEnabled:YES];
}
*/
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
    [self.delegate performSegue:@"profileSegue" didTap:self.post.author];
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

- (NSMutableAttributedString *) makeString: (NSString *) username withAppend: (NSString *) caption {
    NSString *frontAddSpace = [username stringByAppendingString:@" "];
    NSString *fullText = [frontAddSpace stringByAppendingString:caption];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:fullText];
    NSRange boldRange = [fullText rangeOfString:username];
    [attrString addAttribute: NSFontAttributeName value:[UIFont boldSystemFontOfSize:18] range:boldRange];
    return attrString;
}

-(void) makePostImage: (PFFileObject *) postFile {
    [postFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!data) {
            return NSLog(@"%@", error);
        }
        self.postImage.image = [UIImage imageWithData:data];
    }];
}


@end
