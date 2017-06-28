//
//  LoginVCViewController.m
//  PortretOn
//
//  Created by Pavel Bochilo on 28.06.17.
//  Copyright © 2017 Pavel Bochilo. All rights reserved.
//

#import "LoginVCViewController.h"
#import "WebServiceManager.h"

@interface LoginVCViewController ()

@end

@implementation LoginVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationStartLoadingUserData)
                                                 name:@"userNotification"
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
    NSString* authURL = nil;

    authURL = [NSString stringWithFormat: @"%@?client_id=%@&redirect_uri=%@&response_type=code&scope=%@&DEBUG=True",
               INSTAGRAM_AUTHURL,
               INSTAGRAM_CLIENT_ID,
               INSTAGRAM_REDIRECT_URI,
               INSTAGRAM_SCOPE];

    [loginWebView loadRequest: [NSURLRequest requestWithURL: [NSURL URLWithString: authURL]]];
    [loginWebView setDelegate:self];
    
}


#pragma mark -
#pragma mark delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    return [self checkRequestForCallbackURL: request];
}

- (void) webViewDidStartLoad:(UIWebView *)webView
{
    
    [loginIndicator startAnimating];
    [loginWebView.layer removeAllAnimations];
    loginWebView.userInteractionEnabled = NO;
    [UIView animateWithDuration: 0.1 animations:^{
        loginWebView.alpha = 1.0;
    }];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [loginWebView.layer removeAllAnimations];
    loginWebView.userInteractionEnabled = YES;
    [UIView animateWithDuration: 0.1 animations:^{
        loginWebView.alpha = 1.0;
    }];
    [loginIndicator stopAnimating];
    loginIndicator.hidden = YES;
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self webViewDidFinishLoad: webView];
}

#pragma mark - login check and requests



- (BOOL) checkRequestForCallbackURL: (NSURLRequest*) request
{
    NSString* urlString = [[request URL] absoluteString];
    
        if([urlString hasPrefix: INSTAGRAM_REDIRECT_URI])
        {
            // extract and handle access token
            NSRange range = [urlString rangeOfString: @"code="];
            [[WebServiceManager sharedInstance] sendPOSTRequestWithCode:[urlString substringFromIndex: range.location+range.length]];
            return NO;
            
        }
    
    return YES;
}


- (void)notificationStartLoadingUserData {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSelector:@selector(pushToTabBarcontroller) withObject:nil afterDelay:1];
    });
}
- (void)pushToTabBarcontroller {
    dispatch_async(dispatch_get_main_queue(), ^{        
    [self performSegueWithIdentifier:@"firstSeque" sender:nil];
    });
}



@end
