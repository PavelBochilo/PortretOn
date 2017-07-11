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
}

- (void)populateCellWith:(NSDictionary *)dict delegateWith:(UIViewController *)controller {
    [self setAvatarForHeader];

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
