//
//  UserPostCollectionCell.m
//  Instagram
//
//  Created by aliu18 on 7/10/19.
//  Copyright © 2019 aliu18. All rights reserved.
//

#import "UserPostCollectionCell.h"
#import "Post.h"
#import "InstagramHelper.h"

@implementation UserPostCollectionCell

#pragma mark - UserPostCollectionCell lifecycle

- (void) setImage: (Post *) post {
    _post = post;
    makePostforImage(self.postImage, post.image);
}

@end
