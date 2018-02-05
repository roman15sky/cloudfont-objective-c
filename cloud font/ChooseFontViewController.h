//
//  ChooseFontViewController.h
//  cloud font
//
//  Created by Roman on 24/03/2017.
//  Copyright © 2017 Elane Hy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChooseFontViewControllerDelegate <NSObject>

- (void) changeFont : (NSString *)fontname;

@end


@interface ChooseFontViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIPickerView *fontsPickerView;
@property (nonatomic, strong) NSMutableArray* fontArray;

@property (nonatomic, weak) id <ChooseFontViewControllerDelegate> delegate;
@end
