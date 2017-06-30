//
//  Defines.h
//  PortretOn
//
//  Created by Pavel Bochilo on 28.06.17.
//  Copyright © 2017 Pavel Bochilo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Defines : NSObject

#define INSTAGRAM_AUTHURL               @"https://api.instagram.com/oauth/authorize/"
#define INSTAGRAM_APIURl                @"https://api.instagram.com/v1/users/"
#define INSTAGRAM_CLIENT_ID             @"91a629b8df8c41c4940e6d23288412e3"
#define INSTAGRAM_CLIENTSERCRET         @"a4d927538f134e78b94effc6f8c06aeb"
#define INSTAGRAM_REDIRECT_URI          @"http://yourcallback.com/"
#define INSTAGRAM_ACCESS_TOKEN          @"access_token"
#define INSTAGRAM_SCOPE                 @"basic+public_content+follower_list+comments+relationships+likes"
#define INSTAGRAM_API_USER              @"https://api.instagram.com/v1/users/{user-id}/?access_token=ACCESS-TOKEN"
#define INSTAGRAM_MEDIA                 @"https://api.instagram.com/v1/media/{media-id}?access_token=ACCESS-TOKEN"
#define INSTAGRAM_API_SELF              @"https://api.instagram.com/v1/users/self/?access_token=ACCESS-TOKEN"
#define INSTAGRAM_USER_FOLLOWES         @"https://api.instagram.com/v1/users/self/follows?access_token=ACCESS-TOKEN"
#define INSTAGRAM_USER_FOLLOWES_BY      @"https://api.instagram.com/v1/users/self/followed-by?access_token=ACCESS-TOKEN"


@end
