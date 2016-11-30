//
//  MLViewController.m
//  MLNavigationBarTransition
//
//  Created by molon on 2016/11/28.
//  Copyright © 2016年 molon. All rights reserved.
//

#import "MLViewController.h"
#import <MLKit.h>

@implementation MLNavigationBarConfig
@end

@interface MLViewController ()

@end

@implementation MLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
