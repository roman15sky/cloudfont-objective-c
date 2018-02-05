//
//  ShopViewController.m
//  cloud font
//
//  Created by Roman on 04/04/2017.
//  Copyright © 2017 Elane Hy. All rights reserved.
//

#import "ShopViewController.h"
#import <WebKit/WebKit.h>

@interface ShopViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    NSURL *url = [NSURL URLWithString:@"https://www.designfontapps.com/selltshirts/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //    [_webView setScalesPageToFit:YES];
    [self.webView loadRequest:request];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Action
- (IBAction)onCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
