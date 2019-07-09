//
//  Post.m
//  Instagram
//
//  Created by aliu18 on 7/8/19.
//  Copyright © 2019 aliu18. All rights reserved.
//

#import "Post.h"
#import "Parse/Parse.h"

@implementation Post

@dynamic postID;
@dynamic userID;
@dynamic author;
@dynamic caption;
@dynamic image;
@dynamic likeCount;
@dynamic commentCount;

#pragma mark - Parse identifier

+ (nonnull NSString *)parseClassName {
    return @"Post";
}

#pragma mark - create post

+ (void) postUserImage: ( UIImage * _Nullable )image withCaption: ( NSString * _Nullable )caption withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Post *newPost = [Post new];
    newPost.image = [self getPFFileFromImage:image];
    newPost.author = [PFUser currentUser];
    newPost.caption = caption;
    newPost.likeCount = @(0);
    newPost.commentCount = @(0);
    
    [newPost saveInBackgroundWithBlock: completion];
}

#pragma mark - Make PFFile

+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
        if (!image) {
        return nil;
    }
    NSData *imageData = UIImagePNGRepresentation(image);
    if (!imageData) {
        return nil;
    }
    
    //CHANGE MADE AFTER REFERENCING STACKOVERFLOW!!!
   //PFFile --> PFFileObject and fileWithName --> fileObjectWithName //https://stackoverflow.com/questions/54500145/parse-undeclared-type-pffile-pod-1-17-2
    //https://parseplatform.org/Parse-SDK-iOS-OSX/api/Classes/PFFileObject.html#/c:objc(cs)PFFileObject(cm)fileObjectWithName:data:
    //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

@end
