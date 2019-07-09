//
//  PostCell.m
//  Instagram
//
//  Created by aliu18 on 7/8/19.
//  Copyright © 2019 aliu18. All rights reserved.
//

#import "PostCell.h"
#import "Post.h"

@implementation PostCell

#pragma mark - PostCell lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void) setPost: (Post *) post {
    _post = post;
    self.comment.text = post.caption;
    //[self setPostImage: post.image];
    //self.postImage.image = post.image;
}

/*
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
*/
/*
-(void) setPostImage: (PFFileObject *) postFile {
    [postFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!data) {
            return NSLog(@"%@", error);
        }
        self.postImage.image = [UIImage imageWithData:data];
    }];
}
*/

@end
