//
//  DesignViewController.m
//  cloud font
//
//  Created by Roman on 23/03/2017.
//  Copyright © 2017 Elane Hy. All rights reserved.
//

#import "DesignViewController.h"
#import "InputTextViewController.h"
#import "ChooseFontViewController.h"
#import "ChooseColorViewController.h"
#import "CloudLayoutOperation.h" // For <CloudLayoutOperationDelegate> protocol

#import "UIFont+CloudSettings.h" // For LALSettingsFont
#import "UIColor+CloudSettings.h" // For LALSettingsColor


NSString * const kLALuserSettingsSourceKey = @"LALuserSettingsSourceKey";
NSString * const kLALuserSettingsVersionKey = @"LALuserSettingsVersionKey";
NSString * const kLALuserSettingsFontKey = @"LALuserSettingsFontKey";
NSString * const kLALuserSettingsColorKey = @"LALuserSettingsColorKey";
NSString * const kLALuserSettingsStopwordsKey = @"LALuserSettingsStopwordsKey";
NSString * const kLALshowHintCloudTapKey = @"LALshowHintCloudTapKey";
NSString * const kLALshowHintCloudSwipeKey = @"LALshowHintCloudSwipeKey";
NSString * const kLALshowAnimationCloudTitleKey = @"LALshowAnimationCloudTitleKey";


@interface DesignViewController () <CloudLayoutOperationDelegate, ChooseFontViewControllerDelegate, ChooseColorViewControllerDelegate, InputTextViewControllerDelegate>

/**
 A strong reference to an array of UIColor cloud colors
 
 @note These colors are related to the currentColorPreference enum
 */
@property (nonatomic, strong) NSArray *cloudColors;
/**
 A strong reference to the current cloud font name
 */
@property (nonatomic, strong) NSString *cloudFontName;
/**
 A strong reference to the cloud layout operation queue
 
 @note This is a sequential operation queue that handles the layout for the cloud words
 */
@property (nonatomic, strong) NSOperationQueue *cloudLayoutOperationQueue;
/**
 The current source preference for the cloud's words
 
 @note This is the bible, the old or new testament, or a specific bible book
 */
@property (nonatomic, assign) NSInteger currentSourcePreference;
/**
 The current (bible) version preference for the cloud's words
 */
@property (nonatomic, assign) NSInteger currentVersionPreference;
/**
 The current font preference for the cloud's words
 */
@property (nonatomic, assign) LALSettingsFont currentFontPreference;
/**
 The current color preference for the cloud's words
 */
@property (nonatomic, assign) LALSettingsColor currentColorPreference;

@property (nonatomic, strong) UILabel *wordLabel;

@property (nonatomic, strong) NSString*  currentText;


@end

@implementation DesignViewController

@synthesize cloudColors = _cloudColors;
@synthesize cloudFontName = _cloudFontName;
@synthesize cloudLayoutOperationQueue = _cloudLayoutOperationQueue;
@synthesize currentSourcePreference = _currentSourcePreference;
@synthesize currentVersionPreference = _currentVersionPreference;
@synthesize currentFontPreference = _currentFontPreference;
@synthesize currentColorPreference = _currentColorPreference;

#pragma mark - Initialization

// Override to support custom initialization.
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        _wordLabelArray = [[NSMutableArray alloc] initWithCapacity:100000000000000];
        _wordLabelPointSizeArray = [[NSMutableArray alloc] initWithCapacity:100000000000000];
        // Custom initialization
        _cloudLayoutOperationQueue = [[NSOperationQueue alloc] init];
        _cloudLayoutOperationQueue.name = @"Cloud layout operation queue";
        _cloudLayoutOperationQueue.maxConcurrentOperationCount = 1;
        
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter addObserver:self
                               selector:@selector(contentSizeCategoryDidChange:)
                                   name:UIContentSizeCategoryDidChangeNotification
                                 object:nil];
    }
    return self;
}

- (void)dealloc
{
    [_cloudLayoutOperationQueue cancelAllOperations];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self name:UIContentSizeCategoryDidChangeNotification object:nil];
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //crop image
    UIImage *croppedImg = nil;
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"backgroundimage"];
    UIImage *croppingImg = [UIImage imageWithData:imageData];
    CGRect cropRect;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"backgroundimagesize"]  isEqual: @"square"]) {
        // 1:1
        if (croppingImg.size.width < croppingImg.size.height) {
            cropRect = CGRectMake(0, (croppingImg.size.height - croppingImg.size.width)/2, croppingImg.size.width, croppingImg.size.width);
        }else{
            cropRect = CGRectMake((croppingImg.size.width - croppingImg.size.height)/2, 0, croppingImg.size.height, croppingImg.size.height);
        }
        self.designView.frame = CGRectMake(0, 0, (self.view.frame.size.width - 40), (self.view.frame.size.width - 40));
        self.designView.center = self.view.center;
        
    }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"backgroundimagesize"]  isEqual: @"tshirt"]) {
        // 6:5
        if (croppingImg.size.width < croppingImg.size.height) {
            cropRect = CGRectMake(0, (croppingImg.size.height - croppingImg.size.width *6/5)/2, croppingImg.size.width, croppingImg.size.width*6/5);
        }else{
            cropRect = CGRectMake((croppingImg.size.width - croppingImg.size.height *5/6)/2, 0, croppingImg.size.height*5/6, croppingImg.size.height);
        }
        
        self.designView.frame = CGRectMake(0, 0, (self.view.frame.size.width - 40), (self.view.frame.size.width - 40) * 6 / 5);
        self.designView.center = self.view.center;
        
    }
    self.imageView.frame = CGRectMake(0, 0, self.designView.frame.size.width, self.designView.frame.size.height);
    
    croppedImg = [self croppIngimageByImageName:croppingImg toRect:cropRect];
    self.imageView.image = croppedImg;
    
    // Double tap to pop up textview
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doSingleTap:)] ;
    singleTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTap];
    
    [singleTap requireGestureRecognizerToFail:doubleTap];
    
    // Init Font name
    self.cloudFontName = @"AvenirNext-Regular";
    // Init Color
    self.cloudColors = @[[UIColor whiteColor]];
    
    // Init Cloud Word
    self.currentSourcePreference = [[NSUserDefaults standardUserDefaults] integerForKey:kLALuserSettingsSourceKey];
    self.currentVersionPreference = [[NSUserDefaults standardUserDefaults] integerForKey:kLALuserSettingsVersionKey];
    self.currentFontPreference = [[NSUserDefaults standardUserDefaults] integerForKey:kLALuserSettingsFontKey];
    self.currentColorPreference = [[NSUserDefaults standardUserDefaults] integerForKey:kLALuserSettingsColorKey];
    
    [self layoutCloudWords];
    
    if ([_currentText  isEqual: @""]){
        //disable buttons
        
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

- (IBAction)onFont:(id)sender {
    ChooseFontViewController *fontVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ChooseFontViewController"];
    fontVC.delegate = self;
    [self.navigationController presentViewController:fontVC animated:YES completion:nil];
}

- (IBAction)onColor:(id)sender {
    ChooseColorViewController *colorVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ChooseColorViewController"];
    colorVC.delegate = self;
    [self.navigationController presentViewController:colorVC animated:YES completion:nil];
}

- (IBAction)onSave:(id)sender {
//    [self createSnapShotImagesFromUIview];

//    UIImageWriteToSavedPhotosAlbum([self createSnapShotImagesFromUIview], nil, nil, nil);

    [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation([self createSnapShotImagesFromUIview]) forKey:@"finalimage"];
    
    [self performSegueWithIdentifier:@"goShareSegue" sender:nil];
}

#pragma mark - ChooseFontViewControllerDelegate
- (void) changeFont:(NSString *)fontname {
    self.cloudFontName = fontname;
//    [self layoutCloudWords];
    
    for (int i = 0 ; i < _wordLabelArray.count ; i ++) {
        UILabel *label = _wordLabelArray[i];
        float f = [[_wordLabelPointSizeArray objectAtIndex:i] floatValue];
        label.font = [UIFont fontWithName:self.cloudFontName size:f];
    }
}

#pragma mark - ChooseColorViewControllerDelegate
- (void) changeColor:(UIColor *)color {
    self.cloudColors = @[color];

    for (int i = 0 ; i < _wordLabelArray.count ; i ++) {
        UILabel *label = _wordLabelArray[i];
        label.textColor = self.cloudColors[0];
        
    }
}

#pragma mark - InputTextViewControllerDelegate

- (void) changeString:(NSString *)string {
    self.currentText = string;
    [self layoutCloudWords];
}

#pragma mark - Custom Functions
- (UIImage *)croppIngimageByImageName:(UIImage *)imageToCrop toRect:(CGRect)rect
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([imageToCrop CGImage], rect);
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return cropped;
}

-(UIImage *)createSnapShotImagesFromUIview
{
    UIGraphicsBeginImageContext(CGSizeMake(self.designView.frame.size.width,self.designView.frame.size.height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.designView.layer renderInContext:context];
    UIImage *img_screenShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img_screenShot;
}

- (NSArray*) TextFormat {
//    NSString *inputString = @"This is my test text. i am going to split this text by word one by one, I hope that this will work well as i wanted. Now i am working hard to get money. Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions such as an incoming phone call or SMS message or when the user quits the application and it begins the transition to the background state. Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.";
    //    NSString *sep = @" ,!.;:?-_<>()";
    //    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:sep];
    //    NSArray *subString = [inputString componentsSeparatedByCharactersInSet:set];
    
    NSString *inputString = _currentText;
    NSArray *subString = [inputString componentsSeparatedByString:@" "];
    NSMutableArray *wordcountArray = [NSMutableArray arrayWithCapacity:subString.count];
    NSNumber* initvalue = [NSNumber numberWithInt:1];
    for (int i = 0 ; i < (int)subString.count ; i ++) {
        [wordcountArray addObject:initvalue];
    }
    for (int i = 0 ; i < (int)subString.count ; i ++) {
        for (int j = 0 ; j < (int)subString.count ; j ++) {
            if (i != j){
                if (subString[i] == subString[j]) {
                    int tmpcount = [wordcountArray[i] intValue] + 1;
                    wordcountArray[i] = [NSNumber numberWithInt:tmpcount];
                }
            }
        }
    }
    
    
    NSMutableArray *cloudwordmutablearray = [NSMutableArray arrayWithCapacity:subString.count];
    for (int i = 0 ; i < (int)[subString count] ; i ++ ){
        NSDictionary *dic = @{@"title" : subString[i], @"total" : [NSString stringWithFormat:@"%d", (arc4random_uniform(700) + 50) * [wordcountArray[i] intValue]]};
        [cloudwordmutablearray addObject:dic];
    }
    
    NSArray* cloudWords = [cloudwordmutablearray copy];
    return cloudWords;
}

#pragma mark - GestureRecognizer

- (void)doSingleTap : (UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
//        self.notifyLabel.hidden = YES;
        [self layoutCloudWords];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kLALshowHintCloudTapKey];
    }
}

- (void)doDoubleTap : (UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
        self.notifyLabel.hidden = YES;
        InputTextViewController *inputTextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"InputTextViewController"];
        inputTextVC.text = _currentText;
        inputTextVC.delegate = self;
        [self.navigationController presentViewController:inputTextVC animated:YES completion:nil];
        
    }
}

#pragma mark - Public methods

#pragma mark - Scene management

#pragma mark - <CloudLayoutOperationDelegate>

- (void)insertTitle:(NSString *)cloudTitle
{
    
}

- (void)insertWord:(NSString *)word pointSize:(CGFloat)pointSize color:(NSUInteger)color center:(CGPoint)center vertical:(BOOL)isVertical
{
    _wordLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    
    _wordLabel.text = word;
    _wordLabel.textAlignment = NSTextAlignmentCenter;
    _wordLabel.textColor = self.cloudColors[color < self.cloudColors.count ? color : 0];
    _wordLabel.font = [UIFont fontWithName:self.cloudFontName size:pointSize];
    
    [_wordLabel sizeToFit];
    
    // Round up size to even multiples to "align" frame without ofsetting center
    CGRect wordLabelRect = _wordLabel.frame;
    wordLabelRect.size.width = ((NSInteger)((CGRectGetWidth(wordLabelRect) + 3) / 2)) * 2;
    wordLabelRect.size.height = ((NSInteger)((CGRectGetHeight(wordLabelRect) + 3) / 2)) * 2;
    _wordLabel.frame = wordLabelRect;
    
    _wordLabel.center = center;
    
    if (isVertical)
    {
        _wordLabel.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    
    //#ifdef DEBUG
    //    wordLabel.layer.borderColor = [UIColor redColor].CGColor;
    //    wordLabel.layer.borderWidth = 1;
    //#endif
    
    //    [self.view addSubview:wordLabel];
    [self.imageView addSubview:_wordLabel];
    
    //Add current Wordlabel
    [_wordLabelArray addObject:_wordLabel];
    //Add current label's fontsize
    NSNumber *num = [NSNumber numberWithFloat:pointSize];
    [_wordLabelPointSizeArray addObject:num];
}

#ifdef DEBUG
- (void)insertBoundingRect:(CGRect)rect
{
    CALayer *boundingRect = [CALayer layer];
    boundingRect.frame = rect;
    boundingRect.borderColor = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:0.5].CGColor;
    boundingRect.borderWidth = 1;
    [self.imageView.layer addSublayer:boundingRect];
}
#endif

#pragma mark - <UIContentContainer>

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    __weak __typeof__(&*self) weakSelf = self;
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>__unused context) {
        __typeof__(&*weakSelf) strongSelf = weakSelf;
        [strongSelf layoutCloudWords];
    } completion:nil];
}

#pragma mark - <UIStateRestoring>

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super decodeRestorableStateWithCoder:coder];
}

#pragma mark - Notification handlers

/**
 Content size category has changed.  Layout cloud again, to account for new pointSize
 */
- (void)contentSizeCategoryDidChange:(NSNotification *)__unused notification
{
    [self layoutCloudWords];
}


#pragma mark - Private methods

/**
 Remove all words from the cloud view
 */
- (void)removeCloudWords
{
    NSMutableArray *removableObjects = [[NSMutableArray alloc] init];
    
    // Remove cloud words (UILabels)
    
    for (id subview in self.imageView.subviews)
    {
        if ([subview isKindOfClass:[UILabel class]])
        {
            [removableObjects addObject:subview];
        }
    }
    
    [removableObjects makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
#ifdef DEBUG
    // Remove bounding boxes
    
    [removableObjects removeAllObjects];
    
    for (id sublayer in self.imageView.layer.sublayers)
    {
        if ([sublayer isKindOfClass:[CALayer class]] && ((CALayer *)sublayer).borderWidth && ![sublayer delegate])
        {
            [removableObjects addObject:sublayer];
        }
    }
    
    [removableObjects makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
#endif
}

- (void)layoutCloudWords
{
    // Cancel any in-progress layout
    [self.cloudLayoutOperationQueue cancelAllOperations];
    [self.cloudLayoutOperationQueue waitUntilAllOperationsAreFinished];
    
    [self removeCloudWords];
    
    
//    self.view.backgroundColor = [UIColor lal_backgroundColorForPreferredColor:self.currentColorPreference];
    
//    self.cloudFontName = [UIFont lal_fontNameForPreferredFont:self.currentFontPreference];
    
    // Start a new cloud layout operation
    
//    NSArray *cloudWords = [[LALDataSource sharedDataSource] cloudWordsForTopic:self.currentSourcePreference includeRank:NO stopWords:NO inVersion:self.currentVersionPreference];
//    NSString *cloudTitle = [[LALDataSource sharedDataSource] titleForTopic:self.currentSourcePreference inVersion:self.currentVersionPreference];
    
//    
//    NSString *inputString = @"This is my test text. i am going to split this text by word one by one, I hope that this will work well as i wanted. Now i am working hard to get money. Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions such as an incoming phone call or SMS message or when the user quits the application and it begins the transition to the background state. Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.";
//    //    NSString *sep = @" ,!.;:?-_<>()";
//    //    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:sep];
//    //    NSArray *subString = [inputString componentsSeparatedByCharactersInSet:set];
//    
//    NSArray *subString = [inputString componentsSeparatedByString:@" "];
//    NSMutableArray *wordcountArray = [NSMutableArray arrayWithCapacity:subString.count];
//    NSNumber* initvalue = [NSNumber numberWithInt:1];
//    for (int i = 0 ; i < (int)subString.count ; i ++) {
//        [wordcountArray addObject:initvalue];
//    }
//    for (int i = 0 ; i < (int)subString.count ; i ++) {
//        for (int j = 0 ; j < (int)subString.count ; j ++) {
//            if (i != j){
//                if (subString[i] == subString[j]) {
//                    int tmpcount = [wordcountArray[i] intValue] + 1;
//                    wordcountArray[i] = [NSNumber numberWithInt:tmpcount];
//                }
//            }
//        }
//    }
//    
//    
//    NSMutableArray *cloudwordmutablearray = [NSMutableArray arrayWithCapacity:subString.count];
//    for (int i = 0 ; i < (int)[subString count] ; i ++ ){
//        NSDictionary *dic = @{@"title" : subString[i], @"total" : [NSString stringWithFormat:@"%d", (arc4random_uniform(700) + 50) * [wordcountArray[i] intValue]]};
//        [cloudwordmutablearray addObject:dic];
//    }
//    

    NSArray* currentcloudWords = [self TextFormat];
    
    CloudLayoutOperation *newCloudLayoutOperation = [[CloudLayoutOperation alloc] initWithCloudWords:currentcloudWords
                                                                                               title:@"cloud word"
                                                                                            fontName:self.cloudFontName
                                                                                forContainerWithSize:self.imageView.bounds.size
                                                                                               scale:[[UIScreen mainScreen] scale]
                                                                                            delegate:self];
    
    [self.cloudLayoutOperationQueue addOperation:newCloudLayoutOperation];
}


@end
