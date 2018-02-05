//
//  InputTextViewController.h
//  cloud font
//
//  Created by Roman on 23/03/2017.
//  Copyright © 2017 Elane Hy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InputTextViewControllerDelegate <NSObject>

- (void) changeString : (NSString *)string;

@end

@interface InputTextViewController : UIViewController <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic, strong) NSString *text;

@property (nonatomic, weak) id <InputTextViewControllerDelegate> delegate;

@end
