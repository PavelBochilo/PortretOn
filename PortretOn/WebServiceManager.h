//
//  WebServiceManager.h
//  PortretOn
//
//  Created by Pavel Bochilo on 28.06.17.
//  Copyright © 2017 Pavel Bochilo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebServiceManager : UIViewController <NSURLSessionDataDelegate, NSURLSessionDelegate>

//Singleton

+ (WebServiceManager *)sharedInstance;

@property (strong, nonatomic) NSString *myAccessToken;
@property (strong, nonatomic) NSString *mySessionID;

- (void) sendPOSTRequestWithCode: (NSString *) code;


@end
