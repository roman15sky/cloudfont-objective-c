//
//  SizeViewController.m
//  cloud font
//
//  Created by Roman on 23/03/2017.
//  Copyright © 2017 Elane Hy. All rights reserved.
//

#import "SizeViewController.h"
#import "SizeTableViewCell.h"


@interface SizeViewController ()

@end

@implementation SizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Init Data Array
    _sizeTextArray = [[NSArray alloc] initWithObjects:@"SQUARE",@"T-SHIRT", nil];
    _sizeImageArray = [[NSArray alloc] initWithObjects:@"square",@"tshirt", nil ];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIButton Action
- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        //Squre 1:1
        [[NSUserDefaults standardUserDefaults] setValue:@"square" forKey:@"backgroundimagesize"];
    }else if (indexPath.row == 1) {
        //T-Shirt 6:5
        [[NSUserDefaults standardUserDefaults] setValue:@"tshirt" forKey:@"backgroundimagesize"];
    }
    [self performSegueWithIdentifier:@"goDesignSegue" sender:nil];
}

#pragma mark - UITableView DataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sizeTextArray.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"SizeTableViewCell";
    SizeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[SizeTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.sizelabel.text = _sizeTextArray[indexPath.row];
    cell.sizeicon.image = [UIImage imageNamed:_sizeImageArray[indexPath.row]];
    
    return cell;
}



@end
