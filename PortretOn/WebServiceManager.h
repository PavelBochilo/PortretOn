//
//  WebServiceManager.h
//  PortretOn
//
//  Created by Pavel Bochilo on 28.06.17.
//  Copyright © 2017 Pavel Bochilo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginVCViewController.h"

@interface WebServiceManager : NSObject <NSURLSessionDataDelegate, NSURLSessionDelegate>

//Singleton

+ (WebServiceManager *)sharedInstance;

@property (strong, nonatomic) NSString *mySessionID;
@property (strong, nonatomic) LoginVCViewController *loginVc;

@property (strong, nonatomic) UIImage *userAvatarImage;
@property (strong, nonatomic) NSDictionary *userDataDictionary;
@property (strong, nonatomic) NSDictionary *userMediaDictionary;
@property (strong, nonatomic) NSMutableArray *userPhotoUrlArray;
@property (strong, nonatomic) NSMutableArray *userStandartPhotoUrlArray;
@property (strong, nonatomic) NSMutableArray *followsIDArray;
@property (strong, nonatomic) NSMutableArray *followsUserNameArray;
@property (strong, nonatomic) NSMutableArray *followsAvatarUrlArray;
@property (strong) NSMutableArray *allFollowsUserUrlArray;
@property (strong, nonatomic) NSMutableArray *followsFullName;
@property NSUInteger progressCount;


-(void)sendPOSTRequestWithCode:(NSString *)code fromVC:(UIViewController *)loginVc;
-(void)handleMyTokenAndID: (NSString *)myToken andMyName:(NSString *)myFullName;
-(void)senGetRequestUserInfoAndMyID:(NSString *)myID;
-(void)sendRequestForUserMedia;

@end
