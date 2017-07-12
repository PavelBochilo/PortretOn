//
//  MainCollectionReusableView.h
//  PortretOn
//
//  Created by Pavel Bochilo on 07.07.17.
//  Copyright © 2017 Pavel Bochilo. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MainCollectionReusableView : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UIImageView *photoColCell;
- (void)populateCollectionCellWith:(NSString *)urlStr cellNumber:(int)cellNum state:(Boolean)isDefault;

@end
