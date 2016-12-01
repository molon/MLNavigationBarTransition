//
//  UINavigationBar+MLNavigationBarTransition.m
//  MLNavigationBarTransition
//
//  Created by molon on 2016/11/29.
//  Copyright © 2016年 molon. All rights reserved.
//

#import "UINavigationBar+MLNavigationBarTransition.h"
#import "MLNavigationBarTransitionDefine.h"

MLNBT_SYNTH_DUMMY_CLASS(UINavigationBar_MLNavigationBarTransition)

@implementation UINavigationBar (MLNavigationBarTransition)

- (UIView*)ml_backIndicatorView {
    static NSString *ivarKey = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *keys = @[@"_backIndicatorView"];
        for (NSString *key in keys) {
            if (mlnbt_doesIvarExistWithName([self class], key)) {
                ivarKey = key;
                break;
            }
        }
    });
    if (ivarKey) {
        return [self valueForKey:ivarKey];
    }
    
    NSAssert(NO, @"ml_backgroundView is not valid");
    return nil;
}

- (UILabel*)ml_backButtonLabel {
    UINavigationItem *backItem = self.backItem;
    
    UILabel *label = nil;
    @try {
        UIView *backButtonView = [self.backItem valueForKey:@"_backButtonView"];
        label = [backButtonView valueForKey:@"_label"];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
        NSAssert(NO, @"ml_backButtonLabel is not valid");
    }
    
    return label;
}

- (UIView*)ml_backgroundShadowView {
    for (UIView *subv in self.ml_backgroundView.subviews) {
        if ([subv isKindOfClass:[UIImageView class]]&&subv.bounds.size.height<=1.0f) {
            return subv;
        }
    }
    return nil;
}

- (UIView*)ml_backgroundView {
    static NSString *ivarKey = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *keys = @[@"_barBackgroundView",@"_backgroundView"];
        for (NSString *key in keys) {
            if (mlnbt_doesIvarExistWithName([self class], key)) {
                ivarKey = key;
                break;
            }
        }
    });
    if (ivarKey) {
        return [self valueForKey:ivarKey];
    }
    
    NSAssert(NO, @"ml_backgroundView is not valid");
    return nil;
}

- (UIImage*)ml_currentBackgroundImage {
    static NSString *ivarKey = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *keys = @[@"_backgroundImage"];
        for (NSString *key in keys) {
            if (mlnbt_doesIvarExistWithName([self.ml_backgroundView class], key)) {
                ivarKey = key;
                break;
            }
        }
        if (!ivarKey) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
            if ([self.ml_backgroundView respondsToSelector:@selector(_currentCustomBackground)]) {
                ivarKey = @"_currentCustomBackground";
            }
#pragma clang diagnostic pop
        }
    });
    if (ivarKey) {
        return [self.ml_backgroundView valueForKey:ivarKey];
    }
    
    NSAssert(NO, @"ml_currentBackgroundImage is not valid");
    return nil;
}

- (UINavigationBar*)ml_replicantBarOfSameBackgroundEffectWithContainerView:(UIView*)containerView {
    NSAssert(self.window&&[self.window isEqual:containerView.window], @"%@-->\n`containerView.window` must equal to self(UINavigationBar).window",NSStringFromSelector(_cmd));
    
    UINavigationBar *bar = [UINavigationBar new];
    
    bar.tintColor = self.tintColor;
    bar.barStyle = self.barStyle;
    bar.barTintColor = self.barTintColor;
    bar.shadowImage = self.shadowImage;
    
    //backgroundImage
    [bar setBackgroundImage:[self backgroundImageForBarMetrics:UIBarMetricsDefault] forBarMetrics:UIBarMetricsDefault];
    [bar setBackgroundImage:[self backgroundImageForBarMetrics:UIBarMetricsCompact] forBarMetrics:UIBarMetricsCompact];
    [bar setBackgroundImage:[self backgroundImageForBarMetrics:UIBarMetricsDefaultPrompt] forBarMetrics:UIBarMetricsDefaultPrompt];
    [bar setBackgroundImage:[self backgroundImageForBarMetrics:UIBarMetricsCompactPrompt] forBarMetrics:UIBarMetricsCompactPrompt];
    
    //frame
    CGRect frame = self.frame;
    if (containerView) {
        frame = [self.superview convertRect:self.frame toView:containerView];
    }
    if ([UIDevice currentDevice].systemVersion.doubleValue<8.3f) {
        //below iOS8.3, if only use barTintColor, maybe trigger a bug that display a white line leftside.
        //We fix it below
        if (!self.ml_currentBackgroundImage) {
            CGFloat offset = 1.0f/[UIScreen mainScreen].scale+2.0f;
            frame.origin.x -= offset;
            frame.size.width += offset*2;
        }
    }
    bar.frame = frame;
    
    CGRect backgroundViewFrame = self.ml_backgroundView.frame;
    backgroundViewFrame.size.width = bar.frame.size.width;
    bar.ml_backgroundView.frame = frame;
    
    //alpha
    bar.alpha = self.alpha;
    bar.ml_backgroundView.alpha = self.ml_backgroundView.alpha;
    
    //shadow image view alpha and hidden
    bar.ml_backgroundShadowView.hidden = self.ml_backgroundShadowView.hidden;
    bar.ml_backgroundShadowView.alpha = self.ml_backgroundShadowView.alpha;
    
    //_barPosition is important
    @try {
        [bar setValue:@(self.barPosition) forKey:@"_barPosition"];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
        NSAssert(NO, @"setting _barPosition is not valid");
        return nil;
    }
    
    //translucent
    bar.translucent = self.translucent;
    
    return bar;
}

- (BOOL)ml_isSameBackgroundEffectToNavigationBar:(UINavigationBar*)navigationBar {
    if (!navigationBar) {
        return NO;
    }
    
    if (self.barStyle!=navigationBar.barStyle) {
        return NO;
    }
    
    if (!CGSizeEqualToSize(self.frame.size, navigationBar.frame.size)||
        self.alpha!=navigationBar.alpha||
        !CGSizeEqualToSize(self.ml_backgroundView.frame.size, navigationBar.ml_backgroundView.frame.size)||
        self.ml_backgroundView.alpha != navigationBar.ml_backgroundView.alpha||
        self.ml_backgroundShadowView.hidden != navigationBar.ml_backgroundShadowView.hidden ||
        self.ml_backgroundShadowView.alpha != navigationBar.ml_backgroundShadowView.alpha
        ) {
        return NO;
    }
    
    if (!((!self.shadowImage&&!navigationBar.shadowImage)||[self.shadowImage isEqual:navigationBar.shadowImage]||[UIImagePNGRepresentation(self.shadowImage) isEqual:UIImagePNGRepresentation(navigationBar.shadowImage)])) {
        return NO;
    }
    
    //if backgroundImages equal, ignore barTintColor
    UIImage *backgroundImage1 = self.ml_currentBackgroundImage;
    UIImage *backgroundImage2 = navigationBar.ml_currentBackgroundImage;
    if ([backgroundImage1 isEqual:backgroundImage2]||[UIImagePNGRepresentation(backgroundImage1) isEqual:UIImagePNGRepresentation(backgroundImage2)]) {
        return YES;
    }
    
    //if no backgroundImages, barTintColor should be cared
    if (!backgroundImage1&&!backgroundImage2) {
        if (CGColorEqualToColor(self.barTintColor.CGColor, navigationBar.barTintColor.CGColor)) {
            return YES;
        }
    }
    
    return NO;
}

@end
