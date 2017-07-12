//
//  HeaderReusCell.m
//  PortretOn
//
//  Created by Pavel Bochilo on 07.07.17.
//  Copyright © 2017 Pavel Bochilo. All rights reserved.
//

#import "HeaderReusCell.h"
#import "UIImageView+RoundedImageView.h"


@implementation HeaderReusCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.avatarImageView makeRounded];
    self.buttonsArray = @[self.commonViewButton, self.tableViewButton, self.mapViewButton, self.galleryViewButton];
}

- (IBAction)changeLayoutState:(UIButton *)sender {    
    if ([self.profileVc respondsToSelector:@selector(changeLayoutState:)]) {
        [self.profileVc performSelector:@selector(changeLayoutState:)
                             withObject: [NSNumber numberWithInteger:sender.tag]];
    }
}

- (void)populateCellWith:(NSDictionary *)dict delegateWith:(UIViewController *)controller {
    NSLog(@"%@", dict);
    self.profileVc = (ProfileVC *)controller;
    [self setAvatarForHeader];
    if (dict) {
        if ([dict valueForKeyPath:@"data.bio"]) {
            self.bioLabel.text = [dict valueForKeyPath:@"data.bio"];
        }
        if ([dict valueForKeyPath:@"data.full_name"]) {
            self.fullNameLabel.text = [dict valueForKeyPath:@"data.full_name"];
        }
    }
}

- (void)setAvatarForHeader {
    UIImage *avImage = [WebServiceManager sharedInstance].userAvatarImage;
    if (avImage) {
        self.avatarImageView.image = avImage;
    }

}

- (IBAction)editProfile:(id)sender {

}

@end
