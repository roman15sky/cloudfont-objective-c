//
//  BackgroundViewController.h
//  cloud font
//
//  Created by Roman on 23/03/2017.
//  Copyright © 2017 Elane Hy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BackgroundViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *backgroundImageDataArray;

@end
