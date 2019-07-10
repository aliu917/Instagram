//
//  PostDetailsViewController.m
//  Instagram
//
//  Created by aliu18 on 7/9/19.
//  Copyright © 2019 aliu18. All rights reserved.
//

#import "PostDetailsViewController.h"

@interface PostDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *caption;

@end

#pragma mark - C helper methods

static void makePostImage(PFFileObject *postFile, UIImageView *postImage) {
    UIImage *image = [[UIImage alloc] init];
    [postFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!data) {
            return NSLog(@"%@", error);
        }
        postImage.image = [UIImage imageWithData:data];
    }];
}

static NSString * formatDate(NSDate *createdAtOriginalString) {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //[formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    //[formatter setDateFormat:@"E MMM d HH:mm:ss Z y"];
    NSDate *todayDate = [NSDate date];
    double ti = [createdAtOriginalString timeIntervalSinceDate:todayDate];
    ti = ti * -1;
    if(ti < 1) {
        return @"never";
    } else  if (ti < 60) {
        return [NSString stringWithFormat:@"%.00f sec ago", ti];
    } else if (ti < 3600) {
        int diff = round(ti / 60);
        return [NSString stringWithFormat:@"%d min ago", diff];
    } else if (ti < 86400) {
        int diff = round(ti / 60 / 60);
        return[NSString stringWithFormat:@"%d hrs ago", diff];
    } else {
        formatter.dateStyle = NSDateFormatterShortStyle;
        formatter.timeStyle = NSDateFormatterNoStyle;
        return [formatter stringFromDate:createdAtOriginalString];
    }
}

@implementation PostDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.username.text = self.post.author.username;
    self.dateLabel.text = formatDate(self.post.createdAt);
    self.caption.text = self.post.caption;
    //[self makePostImage:self.post.image];
    makePostImage(self.post.image, self.postImage);
}

#pragma mark - PostDetailsViewController helper function
/*
-(NSString *) formatDate: (NSDate *) createdAtOriginalString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //[formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    //[formatter setDateFormat:@"E MMM d HH:mm:ss Z y"];
    NSDate *todayDate = [NSDate date];
    double ti = [createdAtOriginalString timeIntervalSinceDate:todayDate];
    ti = ti * -1;
    if(ti < 1) {
        return @"never";
    } else  if (ti < 60) {
        return [NSString stringWithFormat:@"%.00f sec ago", ti];
    } else if (ti < 3600) {
        int diff = round(ti / 60);
        return [NSString stringWithFormat:@"%d min ago", diff];
    } else if (ti < 86400) {
        int diff = round(ti / 60 / 60);
        return[NSString stringWithFormat:@"%d hrs ago", diff];
    } else {
        formatter.dateStyle = NSDateFormatterShortStyle;
        formatter.timeStyle = NSDateFormatterNoStyle;
        return [formatter stringFromDate:createdAtOriginalString];
    }
}*/

-(void) makePostImage: (PFFileObject *) postFile {
    UIImage *image = [[UIImage alloc] init];
    [postFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!data) {
            return NSLog(@"%@", error);
        }
        self.postImage.image = [UIImage imageWithData:data];
    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
