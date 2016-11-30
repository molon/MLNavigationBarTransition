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
    [super viewWillAppear:animated];
    
    [self updateNavigationBarDisplay];
}

- (void)updateNavigationBarDisplay {
    MLNavigationBarConfig *config = self.navigationBarConfig;
    
    //if config is nil, reset to default, please change below to your own default
    
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
    self.navigationController.navigationBar.ml_backgroundView.alpha = config?config.backgroundAlpha:1.0f;
    
#warning zheg ge 设置无效
    [self.navigationController.navigationBar setShadowImage:config.showShadowImage?nil:[UIImage new]];
    
#warning zheg 设置也无效,而且不但无效，还会影响isSameEffect的判断
    CGRect frame = self.navigationController.navigationBar.ml_backgroundView.frame;
    frame.size.height = (config&&config.backgroundHeight!=-1)?config.backgroundHeight:self.navigationController.navigationBar.frame.size.height-frame.origin.y;
    self.navigationController.navigationBar.ml_backgroundView.frame = frame;
    
    //other default
    
    //Please set translucent to YES,.
    //If it's YES, the self.view.frame.origin.y would be zero.
    //Or if ml_backgroundView.alpha<1.0f, the views below it would be displayed.
    [self.navigationController.navigationBar setTranslucent:YES];
    
    //update status bar style
    [self setNeedsStatusBarAppearanceUpdate];
}

@end
