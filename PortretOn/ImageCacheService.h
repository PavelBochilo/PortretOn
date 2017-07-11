//
//  ImageCacheService.h
//  PortretOn
//
//  Created by Pavel Bochilo on 06.07.17.
//  Copyright © 2017 Pavel Bochilo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageCacheService : NSObject <NSCacheDelegate>

- (void) getUserImage: (int) keyId
                  url: (NSString *) url
           completion: (void (^)(UIImage * image)) handler;

@end
