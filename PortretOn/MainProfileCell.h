//
//  MainProfileCell.h
//  PortretOn
//
//  Created by Pavel Bochilo on 07.07.17.
//  Copyright © 2017 Pavel Bochilo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainProfileCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIButton *publications;
@property (weak, nonatomic) IBOutlet UIButton *folowers;
@property (weak, nonatomic) IBOutlet UIButton *followed;
- (IBAction)editProfile:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;

- (void)populateCellWith:(NSDictionary *)dict delegateWith:(UIViewController *)controller;

@end
