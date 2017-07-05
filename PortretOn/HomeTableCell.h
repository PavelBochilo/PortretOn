//
//  HomeTableCell.h
//  PortretOn
//
//  Created by Pavel Bochilo on 30.06.17.
//  Copyright © 2017 Pavel Bochilo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextView *textViewWithImage;
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
-(void)downloadImageWithIndex:(NSDictionary *)urlsDict;
-(void)wrapiTextByAttributedString;

@end
