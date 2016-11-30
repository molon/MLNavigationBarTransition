//
//  UINavigationBar+MLNavigationBarTransition.h
//  MLNavigationBarTransition
//
//  Created by molon on 2016/11/29.
//  Copyright © 2016年 molon. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationBar (MLNavigationBarTransition)

/**
 back indicator image view
 */
@property (nullable, nonatomic, strong, readonly) UIView *ml_backIndicatorView;

/**
 label on back button
 */
@property (nullable ,nonatomic, strong, readonly) UILabel *ml_backButtonLabel;

/**
 The colored background view of bar
 */
@property (nullable, nonatomic, strong, readonly) UIView *ml_backgroundView;

/**
 Current displaying backgroundImage
 */
@property (nullable, nonatomic, strong, readonly) UIImage *ml_currentBackgroundImage;

/**
 Returns a replicant of the same background effect
 */
- (nullable UINavigationBar*)ml_replicantBarOfSameBackgroundEffect;

/**
 Whether one bar same background effect with other one
 
 @param navigationBar navigationBar
 
 @return bool
 */
- (BOOL)ml_isSameBackgroundEffectToNavigationBar:(UINavigationBar*)navigationBar;

@end

NS_ASSUME_NONNULL_END
