//
//  HeaderReusCell.h
//  PortretOn
//
//  Created by Pavel Bochilo on 07.07.17.
//  Copyright © 2017 Pavel Bochilo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileVC.h"

@interface HeaderReusCell : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIButton *publications;
@property (weak, nonatomic) IBOutlet UIButton *folowers;
@property (weak, nonatomic) IBOutlet UIButton *followed;
- (IBAction)editProfile:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (weak, nonatomic) IBOutlet UIButton *commonViewButton;
@property (weak, nonatomic) IBOutlet UIButton *tableViewButton;
@property (weak, nonatomic) IBOutlet UIButton *mapViewButton;
@property (weak, nonatomic) IBOutlet UIButton *galleryViewButton;
@property (weak)  ProfileVC *profileVc;
@property (strong) NSArray *buttonsArray;

- (IBAction)changeLayoutState:(UIButton *)sender;


- (void)populateCellWith:(NSDictionary *)dict delegateWith:(UIViewController *)controller;

@end
