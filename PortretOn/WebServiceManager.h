//
//  WebServiceManager.h
//  PortretOn
//
//  Created by Pavel Bochilo on 28.06.17.
//  Copyright © 2017 Pavel Bochilo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginVCViewController.h"

@interface WebServiceManager : UIViewController <NSURLSessionDataDelegate, NSURLSessionDelegate>

//Singleton

+ (WebServiceManager *)sharedInstance;

@property (strong, nonatomic) NSString *myAccessToken;
@property (strong, nonatomic) NSString *mySessionID;
@property (strong, nonatomic) LoginVCViewController *loginVc;

- (void) sendPOSTRequestWithCode: (NSString *) code fromVC: (UIViewController *) loginVc;


@end
