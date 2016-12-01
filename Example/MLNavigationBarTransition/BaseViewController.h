//
//  BaseViewController.h
//  MLNavigationBarTransition
//
//  Created by molon on 2016/11/30.
//  Copyright © 2016年 molon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLNavigationBarConfig : NSObject

@property (nonatomic, strong) UIColor *barTintColor;
@property (nonatomic, strong) UIColor *barBackgroundImageColor;

@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *itemColor;

@property (nonatomic, assign) BOOL showShadowImage;

@property (nonatomic, assign) CGFloat backgroundAlpha;

@end

@interface BaseViewController : UIViewController

@property (nonatomic, strong) MLNavigationBarConfig *navigationBarConfig;

- (void)updateNavigationBarDisplay;

@end
