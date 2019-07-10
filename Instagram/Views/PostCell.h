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

@interface PostCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UILabel *comment;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *profilePicture;
@property (strong, nonatomic) Post *post;

- (void) setPost: (Post *) post;

@end

NS_ASSUME_NONNULL_END
