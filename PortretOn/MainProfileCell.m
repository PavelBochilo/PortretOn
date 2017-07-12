//
//  MainProfileCell.m
//  PortretOn
//
//  Created by Pavel Bochilo on 07.07.17.
//  Copyright © 2017 Pavel Bochilo. All rights reserved.
//

#import "MainProfileCell.h"
#import "UIImageView+RoundedImageView.h"

@implementation MainProfileCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.avatarImageView makeRounded];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)populateCellWith:(NSDictionary *)dict delegateWith:(UIViewController *)controller {
    self.avatarImageView.image = [WebServiceManager sharedInstance].userAvatarImage;

}

- (IBAction)editProfile:(id)sender {
}
@end
