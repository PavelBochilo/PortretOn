//
//  BaseVC.m
//  PortretOn
//
//  Created by Pavel Bochilo on 06.07.17.
//  Copyright © 2017 Pavel Bochilo. All rights reserved.
//

#import "BaseVC.h"

@interface BaseVC ()

@end

@implementation BaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setNavigationBarWithTitle: (NSString *)title {    
    [self.navigationItem setTitle:title];
}

@end
