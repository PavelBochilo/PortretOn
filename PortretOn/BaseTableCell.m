//
//  BaseTableCell.m
//  PortretOn
//
//  Created by Pavel Bochilo on 05.07.17.
//  Copyright © 2017 Pavel Bochilo. All rights reserved.
//

#import "BaseTableCell.h"

@implementation BaseTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (UIView *)makeGradinetView {
    
    UIView *view = [[UIView alloc] initWithFrame:self.contentView.bounds];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    gradient.frame = view.bounds;
    gradient.startPoint = CGPointMake(0.0, 0.5);
    gradient.endPoint = CGPointMake(1.0, 0.5);
    gradient.colors = @[(id)[UIColor blueColor].CGColor,
                        (id)[UIColor whiteColor].CGColor];    
    [view.layer insertSublayer:gradient atIndex:0];
    return view;
}


@end
