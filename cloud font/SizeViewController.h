//
//  SizeViewController.h
//  cloud font
//
//  Created by Roman on 23/03/2017.
//  Copyright © 2017 Elane Hy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SizeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *sizeTextArray;
@property (nonatomic, strong) NSArray *sizeImageArray;

@end
