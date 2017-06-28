//
//  WebServiceManager.m
//  PortretOn
//
//  Created by Pavel Bochilo on 28.06.17.
//  Copyright © 2017 Pavel Bochilo. All rights reserved.
//

#import "WebServiceManager.h"
#import "Defines.h"

@interface WebServiceManager ()

@end

@implementation WebServiceManager

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Singleton
+ (WebServiceManager *)sharedInstance {
    static WebServiceManager *serviceManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serviceManager = [[WebServiceManager alloc] init];
    });
    return serviceManager;
}

- (void) handleMyTokenAndID:(NSString *)myToken andMyName:(NSString *)myFullName  {
    _myAccessToken = myToken;
    _mySessionID = myFullName;
    
    NSLog(@"My token succesfully saved, here it is - %@", _myAccessToken);
    NSLog(@"My ID was saved -- %@", _mySessionID);
    [self.loginVc pushToTabBarcontroller];

}

- (void) sendPOSTRequestWithCode: (NSString *) code fromVC: (UIViewController *) loginVc {
    
    self.loginVc = (LoginVCViewController*) loginVc;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate: nil delegateQueue:nil];
    NSString *post = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&grant_type=authorization_code&redirect_uri=%@&code=%@",INSTAGRAM_CLIENT_ID,INSTAGRAM_CLIENTSERCRET,INSTAGRAM_REDIRECT_URI,code];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *requestData = [NSMutableURLRequest requestWithURL:
                                        [NSURL URLWithString:@"https://api.instagram.com/oauth/access_token"]];
    [requestData setHTTPMethod:@"POST"];
    [requestData setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [requestData setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [requestData setHTTPBody:postData];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:requestData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        //        NSLog(@"This is me Dictionary, JSONSerialization from data === %@", dict);
        NSMutableDictionary * userDict = [[NSMutableDictionary alloc] init];
        userDict = [dict valueForKey:@"user"];
        [self handleMyTokenAndID:[dict valueForKey:@"access_token"] andMyName:[userDict valueForKey:@"id"]];
    }];
    
    [postDataTask resume];
}


@end
