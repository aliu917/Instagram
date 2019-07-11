//
//  CommentViewController.h
//  Instagram
//
//  Created by aliu18 on 7/11/19.
//  Copyright © 2019 aliu18. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommentViewController : UIViewController

@property (strong, nonatomic) Post *post;

@end

NS_ASSUME_NONNULL_END
