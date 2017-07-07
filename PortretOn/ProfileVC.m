//
//  ProfileVC.m
//  PortretOn
//
//  Created by Pavel Bochilo on 06.07.17.
//  Copyright © 2017 Pavel Bochilo. All rights reserved.
//

#import "ProfileVC.h"
#import "HomeTableCell.h"
#import "ImageCacheService.h"
#import "MainProfileCell.h"

static  NSString * mainProfileCell = @"MainProfileCell";

@interface ProfileVC ()
@property (strong, nonatomic) ImageCacheService *cache;
@property (nonatomic) int step;
@end

@implementation ProfileVC


- (void)viewDidLoad {
    [super viewDidLoad];
    [self startNoticicationProcess];
    [self setNavigationBarWithTitle:
     [[WebServiceManager sharedInstance].userDataDictionary valueForKeyPath:@"data.full_name"]];
}

- (void)registerAllNibs {
    [self.tableView registerNib:[UINib nibWithNibName:mainProfileCell bundle:nil]
         forCellReuseIdentifier:mainProfileCell];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];

}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
}

- (void)reloadMyTableView {
    self.step = 1;
    [self.tableView reloadData];
    self.tableView.hidden = NO;
    [self.indicator stopAnimating];
}

#pragma mark - TableView Cell Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 250;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *currentId = [[NSString alloc] initWithFormat: @"cellProf%ld", indexPath.section];
    if (indexPath.section == 0) {
        [self.tableView registerNib:[UINib nibWithNibName:mainProfileCell bundle:nil] forCellReuseIdentifier:currentId];
        MainProfileCell * cell = (MainProfileCell *)[tableView dequeueReusableCellWithIdentifier: currentId];
        NSDictionary *userDict = [WebServiceManager sharedInstance].userDataDictionary;
        [cell populateCellWith:userDict delegateWith:self];
        return cell;
    } else {
        MainProfileCell * cell = (MainProfileCell *)[tableView dequeueReusableCellWithIdentifier: currentId];
        return cell;
    
    }
}

- (void)startNoticicationProcess {
    self.tableView.hidden = YES;
    self.step = 0;
    [self.indicator startAnimating];
    self.cache = [[ImageCacheService alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationStartLoadingMedia)
                                                 name:@"userMediaNotification"
                                               object:nil];
    [[WebServiceManager sharedInstance] sendRequestForUserMedia];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void) notificationStartLoadingMedia {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSelector:@selector(reloadMyTableView) withObject:nil afterDelay:0.1];        
    });
}

@end
