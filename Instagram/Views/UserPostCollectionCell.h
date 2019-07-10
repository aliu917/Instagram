//
//  UserPostCollectionCell.h
//  Instagram
//
//  Created by aliu18 on 7/10/19.
//  Copyright © 2019 aliu18. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserPostCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (strong, nonatomic) Post *post;

- (void) setImage: (Post *) post;

@end

NS_ASSUME_NONNULL_END
