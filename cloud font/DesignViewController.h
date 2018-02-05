//
//  DesignViewController.h
//  cloud font
//
//  Created by Roman on 23/03/2017.
//  Copyright © 2017 Elane Hy. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 A key to the user's preferred (cloud) source
 
 @note This is the bible, the old or new testament, or a specific bible book
 */
extern NSString * const kLALuserSettingsSourceKey;
/**
 A key to the user's preferred (bible) version
 */
extern NSString * const kLALuserSettingsVersionKey;
/**
 A key to an LALSettingsFont enum of the user's preferred (cloud) font
 */
extern NSString * const kLALuserSettingsFontKey;
/**
 A key to an LALSettingsColor enum of the user's preferred (cloud) color
 */
extern NSString * const kLALuserSettingsColorKey;
/**
 A key to the user's preferred stopwords setting
 
 @note Stopwords never appear in the cloud, but can be toggled for the statistics
 */
extern NSString * const kLALuserSettingsStopwordsKey;
/**
 A key to a BOOL indicating whether the tap gesture hint should be shown
 */
extern NSString * const kLALshowHintCloudTapKey;
/**
 A key to a BOOL indicating whether the swipe gesture hint should be shown
 */
extern NSString * const kLALshowHintCloudSwipeKey;
/**
 A key to a BOOL indicating whether the cloud title animation should be shown
 */
extern NSString * const kLALshowAnimationCloudTitleKey;


@interface DesignViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *wordLabelArray;
@property (nonatomic, strong) NSMutableArray *wordLabelPointSizeArray;

@property (weak, nonatomic) IBOutlet UIView *designView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *notifyLabel;

@end
