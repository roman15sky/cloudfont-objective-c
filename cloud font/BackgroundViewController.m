//
//  BackgroundViewController.m
//  cloud font
//
//  Created by Roman on 23/03/2017.
//  Copyright © 2017 Elane Hy. All rights reserved.
//

#import "BackgroundViewController.h"
#import "BackgroundCollectionViewCell.h"

@interface BackgroundViewController ()

@end

@implementation BackgroundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Init Data Array
    _backgroundImageDataArray = [NSMutableArray arrayWithCapacity:100];
    for (int i = 0 ; i < 50 ; i ++) {
        [_backgroundImageDataArray addObject:[NSString stringWithFormat:@"Image-%d", i]];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Actions
- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UICollectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.backgroundImageDataArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BackgroundCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"BackgroundCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundImage.image = [UIImage imageNamed:self.backgroundImageDataArray[indexPath.row]];
    return cell;
}

#pragma mark - UICollectionViewLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.collectionView.frame.size.width - 60) / 2, (self.collectionView.frame.size.width - 60) / 2);
}

#pragma mark - UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation([UIImage imageNamed:self.backgroundImageDataArray[indexPath.row]]) forKey:@"backgroundimage"];
    [self performSegueWithIdentifier:@"goSizeSegue" sender:nil];
}

@end
