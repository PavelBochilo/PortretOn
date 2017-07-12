//
//  HomeHeaderCell.h
//  PortretOn
//
//  Created by Pavel Bochilo on 05.07.17.
//  Copyright © 2017 Pavel Bochilo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableCell.h"

@interface HomeHeaderCell : BaseTableCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *gradientImage;

- (void)downloadImageWithIndexAndSetName:(NSDictionary *)urlsDict;
@end
