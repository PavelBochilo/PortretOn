//
//  MainCollectionReusableView.m
//  PortretOn
//
//  Created by Pavel Bochilo on 07.07.17.
//  Copyright © 2017 Pavel Bochilo. All rights reserved.
//

#import "MainCollectionReusableView.h"
#import "ImageCacheService.h"

@implementation MainCollectionReusableView {
    ImageCacheService *photoCashe;
}


- (void)awakeFromNib {
    [super awakeFromNib];
}


- (void)populateCollectionCellWith:(NSString *)urlStr cellNumber:(int)cellNum {
    if (!photoCashe) {
        photoCashe = [[ImageCacheService alloc] init];
    }
    
   [photoCashe getUserImage:cellNum url:urlStr completion:^(UIImage *image) {
       if (image) {
           self.photoColCell.image = image;
       }
   }];
    
}



@end
