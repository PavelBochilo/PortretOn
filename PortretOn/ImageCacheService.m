//
//  ImageCacheService.m
//  PortretOn
//
//  Created by Pavel Bochilo on 06.07.17.
//  Copyright © 2017 Pavel Bochilo. All rights reserved.
//

#import "ImageCacheService.h"


@implementation ImageCacheService  {

NSCache * cache;
}

const NSString * imageCacheKeyPrefix = @"image_";

-(id) init {
    self = [super init];
    if(self) {
        cache = [[NSCache alloc] init];
        cache.countLimit = 1000;
    }
    return self;
}

- (void) getImage: (NSString *) key
        imagePath: (NSString *) imagePath
       completion: (void (^)(UIImage * image)) handler
{
    UIImage * image = [cache objectForKey: key];
    
    
    if(  image != nil)
    {
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            handler(image);
        });
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW,0ul ),^(void){
            NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imagePath]];
            UIImage * image = [UIImage imageWithData: data];
            
            if( !image)
            {
                return;
            }
            [cache setObject:image forKey: key];
          //  NSLog(@"%@ == CACHED", image);
            dispatch_async(dispatch_get_main_queue(), ^(void){
                handler(image);
            });
        });
    }
}


- (void) getUserImage: (int) keyId
                  url: (NSString *) url
           completion: (void (^)(UIImage * image)) handler {
    [self getImage: [NSString stringWithFormat: @"%@%d", imageCacheKeyPrefix, keyId]
         imagePath: url 
        completion: handler];
}

@end
