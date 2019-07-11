//
//  PostCell.h
//  Instagram
//
//  Created by aliu18 on 7/8/19.
//  Copyright © 2019 aliu18. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PostCellDelegate;

@interface PostCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UILabel *comment;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIImageView *likeImage;
@property (strong, nonatomic) Post *post;
//@property (nonatomic) BOOL favorited;
//@property (nonatomic) int favoriteCount;
@property (nonatomic, weak) id<PostCellDelegate> delegate;
//@property (nonatomic) BOOL doubleTapLike;

- (void) setPost: (Post *) post;

@end

@protocol PostCellDelegate

- (void)performSegue:(NSString *)segueID didTap:(PFUser *)user;

@end

NS_ASSUME_NONNULL_END
