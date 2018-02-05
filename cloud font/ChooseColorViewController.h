//
//  ChooseColorViewController.h
//  cloud font
//
//  Created by Roman on 24/03/2017.
//  Copyright © 2017 Elane Hy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RGSColorSlider.h"

@protocol ChooseColorViewControllerDelegate <NSObject>

- (void) changeColor : (UIColor *)color;

@end

@interface ChooseColorViewController : UIViewController

@property (weak, nonatomic) IBOutlet RGSColorSlider *colorSlider;

@property (nonatomic, weak) id <ChooseColorViewControllerDelegate> delegate;
@end
