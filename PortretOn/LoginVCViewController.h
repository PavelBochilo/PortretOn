//
//  LoginVCViewController.h
//  PortretOn
//
//  Created by Pavel Bochilo on 28.06.17.
//  Copyright © 2017 Pavel Bochilo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"

@interface LoginVCViewController : UIViewController  <UIWebViewDelegate, NSURLSessionDataDelegate>  {
    
    IBOutlet UIWebView *loginWebView;
    IBOutlet UIActivityIndicatorView *loginIndicator;
}

@property (strong,nonatomic) NSString *typeOfAuthentication;
- (void) pushToTabBarcontroller;

@end
