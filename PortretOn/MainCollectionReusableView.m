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


- (void)populateCollectionCellWith:(NSString *)urlStr cellNumber:(int)cellNum state:(Boolean)isDefault {
    if (!photoCashe) {
        photoCashe = [[ImageCacheService alloc] init];
    }
    [self.indicator startAnimating];
    int stateInt = 0;
    NSString *currentUrl = [NSString string];
    if (isDefault == 0) {
        stateInt = cellNum;
        currentUrl = [NSString stringWithFormat: @"%@",
                      [WebServiceManager sharedInstance].userPhotoUrlArray[cellNum]];
    } else {
        stateInt = 1000 + cellNum;
        currentUrl = [NSString stringWithFormat: @"%@",
                      [WebServiceManager sharedInstance].userStandartPhotoUrlArray[cellNum]];
    }
    
   [photoCashe getUserImage:stateInt url:currentUrl completion:^(UIImage *image) {
       if (image) {
           self.photoColCell.image = image;
           [self.indicator stopAnimating];
       }
   }];    
}



@end
