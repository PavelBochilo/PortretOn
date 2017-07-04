//
//  UrlCredential.m
//  PortretOn
//
//  Created by Pavel Bochilo on 04.07.17.
//  Copyright © 2017 Pavel Bochilo. All rights reserved.
//

#import "UrlCredential.h"

@implementation UrlCredential

- (id)init {
    if ((self = [super init])) {
        _keychainData = [[NSURLCredential alloc] init];
        NSURL *url = [NSURL URLWithString:@"http://www.example.com"];
        _protSpace = [[NSURLProtectionSpace alloc] initWithHost:url.host
                                                                          port:[url.port integerValue]
                                                                      protocol:url.scheme
                                                                         realm:nil
                                                          authenticationMethod:NSURLAuthenticationMethodHTTPDigest];
    }
    return self;
}

-(void)addNewData:(NSString *)idUser andWithTokenPass:(NSString *)tok {
    _keychainData = [NSURLCredential credentialWithUser:idUser
                                               password:tok persistence:NSURLCredentialPersistencePermanent];
    [[NSURLCredentialStorage sharedCredentialStorage] setCredential:_keychainData forProtectionSpace:_protSpace];


}

-(NSDictionary *)returnUserDict {
    NSURLCredential *credential;
    NSDictionary *credentials = [[NSDictionary alloc] init];    
    credentials = [[NSURLCredentialStorage sharedCredentialStorage] credentialsForProtectionSpace:_protSpace];
    credential = [credentials.objectEnumerator nextObject];
    NSLog(@"User %@ already connected with password %@", credential.user, credential.password);
    return credentials;
}

-(void)resetCredentials{
    NSURLCredential *credential;
    NSDictionary *credentials;
    credentials = [[NSURLCredentialStorage sharedCredentialStorage] credentialsForProtectionSpace:_protSpace];
    credential = [credentials.objectEnumerator nextObject];
    [[NSURLCredentialStorage sharedCredentialStorage] removeCredential:credential forProtectionSpace:_protSpace];
}

@end
