//
//  HomeViewController.m
//  cloud font
//
//  Created by Roman on 23/03/2017.
//  Copyright © 2017 Elane Hy. All rights reserved.
//

#import "HomeViewController.h"
#import "ShopViewController.h"

@interface HomeViewController ()


@end


@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Button Actions
- (IBAction)onCamera:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)onGallery:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)onBgs:(id)sender {
    [self performSegueWithIdentifier:@"goBgsSegue" sender:nil];
}

- (IBAction)onPro:(id)sender {
    
}

- (IBAction)onShop:(id)sender {
    //open url
//    UIApplication *application = [UIApplication sharedApplication];
//    NSURL *URL = [NSURL URLWithString:@"https://www.designfontapps.com/selltshirts/"];
//    [application openURL:URL options:@{} completionHandler:^(BOOL success) {
//        if (success) {
//            NSLog(@"Opened url");
//        }
//    }];
    ShopViewController *shopVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ShopViewController"];
    [self.navigationController presentViewController:shopVC animated:YES completion:nil];
}

- (IBAction)onStore:(id)sender {
    
}

- (IBAction)onUploadfonts:(id)sender {
    
}

- (IBAction)onFaq:(id)sender {
    
}

#pragma mark - UIPickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    // process image
    [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(chosenImage) forKey:@"backgroundimage"];
    [self performSegueWithIdentifier:@"godicrectSizeSegue" sender:nil];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

@end
