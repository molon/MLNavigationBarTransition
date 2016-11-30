//
//  BaseViewController.m
//  MLNavigationBarTransition
//
//  Created by molon on 2016/11/30.
//  Copyright © 2016年 molon. All rights reserved.
//

#import "BaseViewController.h"

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
    [self.navigationController.navigationBar setBarTintColor:config.barTintColor];
    [self.navigationController.navigationBar setTintColor:config.tintColor];
    [self.navigationController.navigationBar setBackgroundImage:config.barBackgroundImage forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:config.titleTextAttributes];
    [self.navigationController.navigationBar setTranslucent:YES];
}

@end
