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

#pragma mark - Singleton
+ (WebServiceManager *)sharedInstance {
    static WebServiceManager *serviceManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serviceManager = [[WebServiceManager alloc] init];
    });
    return serviceManager;
}


#pragma mark - Base authorization request
- (void)sendPOSTRequestWithCode:(NSString *)code fromVC:(UIViewController *)loginVc {
    self.loginVc = (LoginVCViewController*) loginVc;
    _allFollowsUserUrlArray = [[NSMutableArray alloc] init];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate: nil delegateQueue:nil];
    NSString *post = [NSString stringWithFormat:
                      @"client_id=%@&client_secret=%@&grant_type=authorization_code&redirect_uri=%@&code=%@",
                      INSTAGRAM_CLIENT_ID,INSTAGRAM_CLIENTSERCRET,INSTAGRAM_REDIRECT_URI,code];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *requestData = [NSMutableURLRequest requestWithURL:
                                        [NSURL URLWithString:@"https://api.instagram.com/oauth/access_token"]];
    [requestData setHTTPMethod:@"POST"];
    [requestData setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [requestData setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [requestData setHTTPBody:postData];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:requestData
                                                    completionHandler:^(NSData *data,
                                                                        NSURLResponse *response,
                                                                        NSError *error) {
        
        NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        //        NSLog(@"This is me Dictionary, JSONSerialization from data === %@", dict);
        NSMutableDictionary * userDict =[[NSMutableDictionary alloc] init];
        userDict = [dict valueForKey:@"user"];
        [self handleMyTokenAndID:[dict valueForKey:@"access_token"] andMyName:[userDict valueForKey:@"id"]];
    }];
    
    [postDataTask resume];
}

#pragma mark - handle Token
- (void)handleMyTokenAndID:(NSString *)myToken andMyName:(NSString *)myFullName  {
    _myAccessToken = myToken;
    _mySessionID = myFullName;
    [self senGetRequestUserInfo:_myAccessToken andMyID:_mySessionID];
    NSLog(@"Token and ID succesfully saved");
}


#pragma mark - get main current User Info
- (void)senGetRequestUserInfo:(NSString *)myToken andMyID:(NSString *)myID {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate: self delegateQueue:nil];
    NSMutableURLRequest *requestData = [NSMutableURLRequest
                                        requestWithURL:
                                        [NSURL URLWithString:
                                        [NSString stringWithFormat:
                                          @"https://api.instagram.com/v1/users/%@/?access_token=%@", myID, myToken]]];
    [requestData setHTTPMethod:@"GET"];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:
                          requestData completionHandler:^(NSData *data,
                                                          NSURLResponse *response,
                                                          NSError *error) {
                              
        NSDictionary *userDict = [NSJSONSerialization JSONObjectWithData:
                                  data options:NSJSONReadingAllowFragments error:nil];
        //        NSLog(@"This IS USER DATA === %@", userDict);
        [self saveUserData:userDict];
    }];
    
    [postDataTask resume];
    
}

- (void)saveUserData:(NSDictionary *)userDict {
    dispatch_async(dispatch_get_main_queue(), ^{
        _userDataDictionary = userDict;
        //    NSLog(@"Dict saved === %@", _userDataDictionary);
        NSDictionary *dict1 = [_userDataDictionary objectForKey:@"data"];
        NSString *urlImage = [dict1 objectForKey:@"profile_picture"];
        [self setMyAvatar:urlImage];
    });
}

- (void)setMyAvatar:(NSString *)avatarUrl {
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: avatarUrl]];
        if ( data == nil )
            return;
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *avatarImage = [UIImage imageWithData:data];
            _userAvatarImage = avatarImage;
            [self sendRequestForUserFollows:_myAccessToken andMyID:_mySessionID];
        });
    });
}

- (void)sendRequestForUserFollows:(NSString *)myToken andMyID:(NSString *)myID {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate: self delegateQueue:nil];
    NSMutableURLRequest *requestData = [NSMutableURLRequest requestWithURL:
                                       [NSURL URLWithString:
                                       [NSString stringWithFormat:
                                       @"https://api.instagram.com/v1/users/self/follows?access_token=%@", myToken]]];
    [requestData setHTTPMethod:@"GET"];
    NSURLSessionDataTask *getDataTask = [session dataTaskWithRequest:
                                         requestData completionHandler:^(NSData *data,
                                                                         NSURLResponse *response,
                                                                         NSError *error) {
        NSDictionary *followsDict = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:NSJSONReadingAllowFragments error:nil];
        dispatch_sync(dispatch_get_main_queue(), ^{
            _followsIDArray = [followsDict valueForKeyPath:@"data.id"];
            _followsAvatarUrlArray = [followsDict valueForKeyPath:@"data.profile_picture"];
            _followsUserNameArray = [followsDict valueForKeyPath:@"data.username"];
            _followsFullName = [followsDict valueForKeyPath:@"data.full_name"];
                    NSLog(@"NUmber os folows== %lu", (unsigned long)[_followsIDArray count]);
        });
        if (_followsIDArray != nil) {
            for (int i = 0; i < _followsIDArray.count; i++) {
                
                [self sendRequestForFollowUserMedia:_myAccessToken andUserID:_followsIDArray[i] andIndex:i];
            }
        }
    }];
    
    [getDataTask resume];
}

#pragma mark - get Info All SANDBOX followers of the user 
// Do this

- (void)sendRequestForFollowUserMedia:(NSString *)myToken andUserID:(NSString *)userID andIndex:(int)Index {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate: self delegateQueue:nil];
        NSMutableURLRequest *requestData = [NSMutableURLRequest requestWithURL:
                                           [NSURL URLWithString:
                                           [NSString stringWithFormat:
                                           @"https://api.instagram.com/v1/users/%@/media/recent/?access_token=%@",
                                            userID, myToken]]];
        [requestData setHTTPMethod:@"GET"];
        NSURLSessionDataTask *getDataTask = [session dataTaskWithRequest:
                                             requestData completionHandler:^(NSData *data,
                                                                             NSURLResponse *response,
                                                                             NSError *error) {
   
            if (![self checkHTTPstatusCode:(NSHTTPURLResponse *) response]) {
                NSArray *arr = [[NSArray alloc] init];
                [self addArray:arr];
                return;
            }

            
            NSDictionary *userDict = [NSJSONSerialization JSONObjectWithData:data
                                                                     options:NSJSONReadingAllowFragments error:nil];
            
            NSMutableArray *userArray = [userDict valueForKey:@"data"];
            NSMutableArray *array = [userDict valueForKeyPath:@"data.images.standard_resolution.url"];
            NSMutableArray *arrayType = [userDict valueForKeyPath:@"data.type"];
            NSMutableArray *array2 = [[NSMutableArray alloc] init];
            for (int i = 0; i < array.count; i++) {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                NSDictionary *indexDict = userArray[i];
                [dict setObject:[indexDict valueForKey:@"id"] forKey:@"images_id"];
                [dict setObject:array[i] forKey:@"url"];
                [dict setObject:arrayType[i] forKey:@"type"];
                if ([arrayType[i] isEqualToString:@"video"]) {
                    NSString *stringVideoUrl = [indexDict valueForKeyPath:@"videos.standard_resolution.url"];
                    [dict setObject:stringVideoUrl forKey:@"video_url"];
                }
                [dict setObject:[indexDict valueForKey:@"location"] forKey:@"location"];
                [dict setObject:_followsIDArray[Index] forKey:@"id"];
                [dict setObject:_followsFullName[Index] forKey:@"name"];
                [dict setObject:_followsAvatarUrlArray[Index] forKey:@"avatar"];
                [dict setObject:[indexDict valueForKeyPath:@"likes.count"] forKey:@"likes_count"];
                [array2 addObject:dict];
                if (i == array.count - 1) {
                    [self addArray:array2];
                }
            }
        }];
        [getDataTask resume];
    });
}

- (void)addArray:(NSArray *)value {
    @synchronized (value) {
        if ([value count] != 0) {
            [ _allFollowsUserUrlArray  addObjectsFromArray:value];
        }        
        dispatch_async(dispatch_get_main_queue(),  ^{
            _progressCount =  _progressCount + 1;
            if (_progressCount == _followsIDArray.count) {
                [_loginVc pushToTabBarcontroller];
                NSLog(@"%@", _allFollowsUserUrlArray);
            }
        });
    }
}

#pragma mark - User own info requests
- (void)sendRequestForUserMedia:(NSString *)myToken andMyID:(NSString *)myID {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate: self delegateQueue:nil];
    NSMutableURLRequest *requestData = [NSMutableURLRequest requestWithURL:
                                       [NSURL URLWithString:
                                       [NSString stringWithFormat:
                                       @"https://api.instagram.com/v1/users/self/media/recent/?access_token=%@",
                                        myToken]]];
    [requestData setHTTPMethod:@"GET"];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:
                                          requestData completionHandler:^(NSData *data,
                                                                          NSURLResponse *response,
                                                                          NSError *error) {
       NSDictionary *userDict = [NSJSONSerialization JSONObjectWithData: data
                                                                options:NSJSONReadingAllowFragments
                                                                  error:nil];
        [self saveMediaDictionary:userDict];
    }];
    
    [postDataTask resume];
}

- (void)saveMediaDictionary:(NSDictionary *)mediaDict {
    dispatch_async(dispatch_get_main_queue(), ^{
        _userMediaDictionary = mediaDict;
        _userPhotoUrlArray = [_userMediaDictionary valueForKeyPath:@"data.images.thumbnail.url"];
        _userStandartPhotoUrlArray = [_userMediaDictionary valueForKeyPath:@"data.images.standard_resolution.url"];
        //  NSLog(@"User photo urls === %@", _userStandartPhotoUrlArray);
        [self loadingImagesData];
        
    });
}

#pragma mark Cashe images
//TO DO - CASHE the photos of user!
- (void)loadingImagesData {
    for (int i = 0; i < _userPhotoUrlArray.count; i++) {
        
    }
}

- (BOOL)checkHTTPstatusCode:(NSHTTPURLResponse *)response {
    if ((long)[response statusCode] != 200) {        
        return NO;
    }
    return YES;
}

#pragma mark - Delete cookies
//Logout method for Instagram API - because of there is no special method request

- (void)deleteCookies {
    NSHTTPCookieStorage *cookeStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [cookeStorage cookies];
    for (int i = 0; i < [cookies count]; i++)
    {
        NSHTTPCookie *cook = [cookies objectAtIndex:i];
        if ([[cook domain] isEqualToString:@"www.instagram.com"] ||
            [[cook domain] isEqualToString:@"api.instagram.com"]) {
            [cookeStorage deleteCookie:cook];
        }
    }
}

@end
