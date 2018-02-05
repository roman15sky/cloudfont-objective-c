//
//  InputTextViewController.m
//  cloud font
//
//  Created by Roman on 23/03/2017.
//  Copyright © 2017 Elane Hy. All rights reserved.
//

#import "InputTextViewController.h"

@interface InputTextViewController ()

@end

@implementation InputTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.textView becomeFirstResponder];
    [self.textView setText:_text];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UItextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        NSLog(@"Return pressed");
        [self.delegate changeString:self.textView.text];
        [textView resignFirstResponder];
        [self dismissViewControllerAnimated:YES completion:nil];
        return NO;
    } else {
        NSLog(@"Other pressed");
    }
    return YES;
}

#pragma mark - UITapGesture
- (IBAction)onTapped:(UITapGestureRecognizer *)sender {
    [self.delegate changeString:self.textView.text];
    [_textView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
