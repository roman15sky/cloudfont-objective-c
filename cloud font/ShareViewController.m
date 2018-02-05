//
//  ShareViewController.m
//  cloud font
//
//  Created by Roman on 24/03/2017.
//  Copyright © 2017 Elane Hy. All rights reserved.
//

#import "ShareViewController.h"
#import <MessageUI/MessageUI.h>

@interface ShareViewController () <MFMailComposeViewControllerDelegate>

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Button Actions
- (IBAction)onBack:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)onHome:(id)sender {
    
}

- (IBAction)onEmail:(id)sender {
    [self shareonSocial];
}

#pragma mark - social share
- (void) shareonSocial {
    
    NSString *sharedMsg=[NSString stringWithFormat:@"Share!"];
    
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"finalimage"];
    UIImage *finalImage = [UIImage imageWithData:imageData];

    NSArray* sharedObjects=[NSArray arrayWithObjects:sharedMsg, finalImage, nil];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]
                                                        initWithActivityItems:sharedObjects applicationActivities:nil];
    activityViewController.popoverPresentationController.sourceView = self.view;
    [self presentViewController:activityViewController animated:YES completion:nil];
    
}


@end
