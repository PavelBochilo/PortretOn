//
//  ImageOffsetButton.m
//  PortretOn
//
//  Created by Pavel Bochilo on 12.07.17.
//  Copyright © 2017 Pavel Bochilo. All rights reserved.
//

#import "ImageOffsetButton.h"

@implementation ImageOffsetButton


- (void)drawRect:(CGRect)rect {
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    double sideLeftRight = self.frame.size.width / 3;
    double topBottom = self.frame.size.height / 4;
    self.imageEdgeInsets = UIEdgeInsetsMake(topBottom, sideLeftRight, topBottom, sideLeftRight);
}

-(void)select:(id)sender {
    if (self.isSelected) {
        [self setTintColor:[UIColor redColor]];
    }
    
}

@end
