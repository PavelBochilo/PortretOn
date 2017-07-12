//
//  HomeVC.h
//  PortretOn
//
//  Created by Pavel Bochilo on 29.06.17.
//  Copyright © 2017 Pavel Bochilo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeVC : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
