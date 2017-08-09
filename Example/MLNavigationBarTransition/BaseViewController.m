//
//  BaseViewController.m
//  MLNavigationBarTransition
//
//  Created by molon on 2016/11/30.
//  Copyright © 2016年 molon. All rights reserved.
//

#import "BaseViewController.h"
#import <UINavigationBar+MLNavigationBarTransition.h>

static inline UIImage *kImageWithColor(UIColor *color) {
    if (!color) {
        return nil;
    }
    CGSize size = CGSizeMake(1, 1);
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@implementation MLNavigationBarConfig
@end

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewWillAppear:(BOOL)animated {
    [self updateNavigationBarDisplay];
    
    [super viewWillAppear:animated];
}

- (void)updateNavigationBarDisplay {
    MLNavigationBarConfig *config = self.navigationBarConfig;
    
    //if config is nil, reset to default, please change logic below with your own default
    
    [self.navigationController.navigationBar setBarTintColor:config.barTintColor];
    
    [self.navigationController.navigationBar setBackgroundImage:kImageWithColor(config.barBackgroundImageColor) forBarMetrics:UIBarMetricsDefault];
    if (config) {
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:config.titleColor}];
    }else{
        [self.navigationController.navigationBar setTitleTextAttributes:nil];
    }
    
    for (UIBarButtonItem *item in self.navigationItem.leftBarButtonItems) {
        item.tintColor = config.itemColor;
    }
    
    for (UIBarButtonItem *item in self.navigationItem.rightBarButtonItems) {
        item.tintColor = config.itemColor;
    }
    //back button tint color
    self.navigationController.navigationBar.tintColor = config.itemColor;
    
    //alpha
    self.navigationController.navigationBar.ml_backgroundAlpha = config?config.backgroundAlpha:1.0f;
    
    //shadow hidden
    self.navigationController.navigationBar.ml_backgroundShadowView.hidden = config?!config.showShadowImage:NO;
    
    //other default
    
    //Please set translucent to YES,.
    //If it's YES, the self.view.frame.origin.y would be zero.
    //Or if ml_backgroundAlpha<1.0f, the views below it would be displayed.
    [self.navigationController.navigationBar setTranslucent:YES];
    
    //update status bar style
    [self setNeedsStatusBarAppearanceUpdate];
}

@end
