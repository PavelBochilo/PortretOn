//
//  UIImageView+RoundedImageView.m
//  PortretOn
//
//  Created by Pavel Bochilo on 05.07.17.
//  Copyright © 2017 Pavel Bochilo. All rights reserved.
//

#import "UIImageView+RoundedImageView.h"

@implementation UIImageView (RoundedImageView)

-(void)makeRounded {
    self.layer.cornerRadius = self.frame.size.height/2;
    self.clipsToBounds = YES;    
}

@end
