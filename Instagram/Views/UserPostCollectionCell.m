//
//  UserPostCollectionCell.m
//  Instagram
//
//  Created by aliu18 on 7/10/19.
//  Copyright © 2019 aliu18. All rights reserved.
//

#import "UserPostCollectionCell.h"
#import "Post.h"

@implementation UserPostCollectionCell

- (void) setImage: (Post *) post {
    NSLog(@"setPost called");
    _post = post;
    [self makePostImage: post.image];
    //self.postImage.image = post.image;
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
