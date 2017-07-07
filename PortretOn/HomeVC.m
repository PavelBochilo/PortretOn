//
//  HomeVC.m
//  PortretOn
//
//  Created by Pavel Bochilo on 29.06.17.
//  Copyright © 2017 Pavel Bochilo. All rights reserved.
//

#import "HomeVC.h"
#import "HomeTableCell.h"
#import "HomeHeaderCell.h"

static NSString *homeCellNibName = @"HomeTableCell";
static NSString *homeHeaderCell = @"HomeHeaderCell";

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
    if ([self.navigationItem respondsToSelector:@selector(setTitle:)]) {
        [self.navigationItem setTitle:@"PortretOn"];
    }
}


- (void)reloadMyTableView {
    [_tableView reloadData];
    
}

#pragma mark - TableView Cell Delegates

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
    [self.tableView registerNib:[UINib nibWithNibName: homeCellNibName bundle:nil]
     forCellReuseIdentifier: currentId];
    
    HomeTableCell *cell = (HomeTableCell *)[tableView dequeueReusableCellWithIdentifier: currentId];
    NSMutableDictionary *indexDict = [WebServiceManager sharedInstance].allFollowsUserUrlArray[indexPath.section];
    
    if ([[indexDict valueForKey:@"type"] isEqualToString:@"video"]) {
        //do nothing... video player TODO
    } else {
        [cell downloadImageWithIndex:indexDict];
        
    }
    return cell;
}

#pragma mark - TableView Header Cell Delegates

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    return 64;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *currentId = [[NSString alloc] initWithFormat: @"header%ld",section];
    [self.tableView registerNib:[UINib nibWithNibName:homeHeaderCell bundle:nil]
     forCellReuseIdentifier:currentId];
    HomeHeaderCell *header = (HomeHeaderCell *)[tableView dequeueReusableCellWithIdentifier:currentId];
    NSDictionary *userData = [[WebServiceManager sharedInstance].allFollowsUserUrlArray objectAtIndex:section];
   // NSLog(@"%@", userData);
    [header downloadImageWithIndexAndSetName:userData];    
    return  header;
}


@end
