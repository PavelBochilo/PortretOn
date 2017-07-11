//
//  HomeHeaderCell.m
//  PortretOn
//
//  Created by Pavel Bochilo on 05.07.17.
//  Copyright © 2017 Pavel Bochilo. All rights reserved.
//

#import "HomeHeaderCell.h"
#import "UIImageView+RoundedImageView.h"

@implementation HomeHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.avatarImage makeRounded];
    [self insertSubview:[self makeGradinetView] atIndex:0];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}



- (void)downloadImageWithIndexAndSetName:(NSDictionary *)urlsDict {

    NSString *urlStringAvatar = urlsDict[@"avatar"];
    NSString *urlStringName = urlsDict[@"name"];
    if (urlStringName != nil || urlStringAvatar != nil) {
        self.nameLabel.text = urlStringName;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: urlStringAvatar]];
            if ( data == nil )
                return;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.avatarImage.image = [UIImage imageWithData: data];
            });
        });
    }
   
}

@end
