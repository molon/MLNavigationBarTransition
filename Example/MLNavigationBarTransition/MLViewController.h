//
//  MLViewController.h
//  MLNavigationBarTransition
//
//  Created by molon on 2016/11/28.
//  Copyright © 2016年 molon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLNavigationBarConfig : NSObject

@property (nonatomic, strong) UIColor *barTintColor;
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, strong) UIImage *barBackgroundImage;
@property (nonatomic, strong) NSDictionary *titleTextAttributes;

@end

@interface MLViewController : UIViewController

@property (nonatomic, strong) MLNavigationBarConfig *navigationBarConfig;

- (void)updateNavigationBarDisplay;

@end
