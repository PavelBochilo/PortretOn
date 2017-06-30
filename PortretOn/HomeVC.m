//
//  HomeVC.m
//  PortretOn
//
//  Created by Pavel Bochilo on 29.06.17.
//  Copyright © 2017 Pavel Bochilo. All rights reserved.
//

#import "HomeVC.h"
#import "HomeTableCell.h"
static NSString *homeCellNibName = @"HomeTableCell";

@interface HomeVC ()

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
}


- (void)reloadTableView {
    [_tableView reloadData];
}

#pragma mark - TableView Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [WebServiceManager sharedInstance].allFollowsUserUrlArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 488;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *currentId = [[NSString alloc] initWithFormat: @"%ld", indexPath.section];
    [_tableView registerNib:[UINib nibWithNibName: homeCellNibName bundle:nil]
     forCellReuseIdentifier: currentId];
    
    HomeTableCell *cell = (HomeTableCell *)[tableView dequeueReusableCellWithIdentifier: currentId];
    NSMutableDictionary *indexDict = [WebServiceManager sharedInstance].allFollowsUserUrlArray[indexPath.section];
    NSLog(@"%@", indexDict);
    if ([[indexDict valueForKey:@"type"] isEqualToString:@"video"]) {
        //do nothing... video player TODO
    } else {
        [cell downloadImageWithIndex:indexDict];
        //[cell wrapiTextByAttributedString];
    }
    return cell;
}


@end
