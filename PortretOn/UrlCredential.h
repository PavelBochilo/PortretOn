//
//  UrlCredential.h
//  PortretOn
//
//  Created by Pavel Bochilo on 04.07.17.
//  Copyright © 2017 Pavel Bochilo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UrlCredential : NSObject

@property (nonatomic, strong) NSURLCredential *keychainData;
@property (nonatomic, strong) NSURLProtectionSpace *protSpace;

-(void)addNewData:(NSString *)idUser andWithTokenPass:(NSString *)tok;
-(NSDictionary *)returnUserDict;
-(void)resetCredentials;

@end
