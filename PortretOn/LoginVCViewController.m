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
    _stage = NO;
    [loginWebView loadRequest: [NSURLRequest requestWithURL: [NSURL URLWithString: authURL]]];
    [loginWebView setDelegate:self];
    
}

#pragma mark - delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    return [self checkRequestForCallbackURL: request];
}

- (void) webViewDidStartLoad:(UIWebView *)webView
{
    
    [self loginIndicatorAnimating:YES];
    [loginWebView.layer removeAllAnimations];
    loginWebView.userInteractionEnabled = NO;
    [UIView animateWithDuration: 0.1 animations:^{
        loginWebView.alpha = 1.0;
    }];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [self loginIndicatorAnimating:NO];
    [loginWebView.layer removeAllAnimations];
    loginWebView.userInteractionEnabled = YES;
    [UIView animateWithDuration: 0.1 animations:^{
        loginWebView.alpha = 1.0;
    }];
}

- (void)loginIndicatorAnimating: (BOOL)isOn {
    if (_stage == YES) {
        return;
    }
    if (isOn == YES) {
        [loginIndicator startAnimating];
        loginIndicator.hidden = NO;
    } else {
         [loginIndicator stopAnimating];
        loginIndicator.hidden = YES;
    }
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
            [self loginIndicatorAnimating:YES];
            _stage = YES;
            [loginWebView removeFromSuperview];
            [[WebServiceManager sharedInstance]
             sendPOSTRequestWithCode:[urlString substringFromIndex: range.location+range.length] fromVC: self];
            return NO;
        }    
    return YES;
}

- (void)pushToTabBarcontroller {
    NSLog(@"Push to Home Screen");
    dispatch_async(dispatch_get_main_queue(), ^{
    _stage = NO;
    [self loginIndicatorAnimating:NO];
    [self performSegueWithIdentifier:@"showTabBar" sender:nil];
    });
}



@end
