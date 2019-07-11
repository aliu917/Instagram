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
    NSLog(@"setPost called");
    _post = post;
    [InstagramHelper makePost: self.postImage forImage: post.image];

}
/*
-(void) makePostImage: (PFFileObject *) postFile {
    [postFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!data) {
            return NSLog(@"%@", error);
        }
        self.postImage.image = [UIImage imageWithData:data];
    }];
}*/

@end
