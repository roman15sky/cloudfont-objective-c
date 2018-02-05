//
//  ChooseColorViewController.m
//  cloud font
//
//  Created by Roman on 24/03/2017.
//  Copyright © 2017 Elane Hy. All rights reserved.
//

#import "ChooseColorViewController.h"
#import "RGSColorSlider.h"

@interface ChooseColorViewController ()

@end

@implementation ChooseColorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - button action
- (IBAction)onDone:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - color slider
- (IBAction)sliderDidChange:(RGSColorSlider *)sender {
    [self.delegate changeColor:sender.color];
}


@end
