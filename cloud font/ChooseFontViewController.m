//
//  ChooseFontViewController.m
//  cloud font
//
//  Created by Roman on 24/03/2017.
//  Copyright © 2017 Elane Hy. All rights reserved.
//

#import "ChooseFontViewController.h"


@interface ChooseFontViewController ()

@end

@implementation ChooseFontViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize FontArray Data
    _fontArray = [[NSMutableArray alloc] initWithCapacity:1000];
    for (NSString *familyName in [UIFont familyNames]){
        NSLog(@"Family name: %@", familyName);
        for (NSString *fontName in [UIFont fontNamesForFamilyName:familyName]) {
            [_fontArray addObject:fontName];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Actions
- (IBAction)onDone:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UIPickerView Delegate & DatsSource

// The number of columns of data
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _fontArray.count;
}
// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _fontArray[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self.delegate changeFont:_fontArray[row]];
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = _fontArray[row];
    NSAttributedString *attString =
    [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    return attString;
}

@end
