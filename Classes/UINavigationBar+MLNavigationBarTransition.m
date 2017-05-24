//
//  UINavigationBar+MLNavigationBarTransition.m
//  MLNavigationBarTransition
//
//  Created by molon on 2016/11/29.
//  Copyright © 2016年 molon. All rights reserved.
//

#import "UINavigationBar+MLNavigationBarTransition.h"
#import "MLNavigationBarTransitionDefine.h"
#import "NSString+MLNavigationBarTransition_Encrypt.h"

MLNBT_SYNTH_DUMMY_CLASS(UINavigationBar_MLNavigationBarTransition)

@interface UINavigationBar(MLNavigationBarTransition_Unpublic)

- (BOOL)_shouldPopForTouchAtPoint:(CGPoint)point;
- (BOOL)_hasBackButton;

@end

@implementation UINavigationBar (MLNavigationBarTransition)

- (UIView*)ml_backIndicatorView {
    static NSString *ivarKey = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    //    NSLog(@"%@:%@",@"_backIndicatorView",[@"_backIndicatorView" mlnbt_EncryptString]);
        NSArray *keys = @[[@"K2WuL2gWozEcL2S0o3WJnJI3" mlnbt_DecryptString]];
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
    UILabel *label = nil;
    @try {
    //    NSLog(@"%@:%@",@"_backButtonView",[@"_backButtonView" mlnbt_EncryptString]);
        UIView *backButtonView = [self.backItem valueForKey:[@"K2WuL2gPqKE0o25JnJI3" mlnbt_DecryptString]];
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
      //  NSLog(@"%@:%@",@"_barBackgroundView",[@"_barBackgroundView" mlnbt_EncryptString]);
      //  NSLog(@"%@:%@",@"_backgroundView",[@"_backgroundView" mlnbt_EncryptString]);
        NSArray *keys = @[[@"K2WupxWuL2gapz91ozEJnJI3" mlnbt_DecryptString],[@"K2WuL2gapz91ozEJnJI3" mlnbt_DecryptString]];
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
    //    NSLog(@"%@:%@",@"_backgroundImage",[@"_backgroundImage" mlnbt_EncryptString]);
        NSArray *keys = @[[@"K2WuL2gapz91ozEWoJSaMD==" mlnbt_DecryptString]];
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
    UINavigationBar *bar = [UINavigationBar new];
    
    bar.tintColor = self.tintColor;
    bar.barStyle = self.barStyle;
    bar.shadowImage = self.shadowImage;
    
    //backgroundImage
    [bar setBackgroundImage:[self backgroundImageForBarMetrics:UIBarMetricsDefault] forBarMetrics:UIBarMetricsDefault];
    [bar setBackgroundImage:[self backgroundImageForBarMetrics:UIBarMetricsCompact] forBarMetrics:UIBarMetricsCompact];
    [bar setBackgroundImage:[self backgroundImageForBarMetrics:UIBarMetricsDefaultPrompt] forBarMetrics:UIBarMetricsDefaultPrompt];
    [bar setBackgroundImage:[self backgroundImageForBarMetrics:UIBarMetricsCompactPrompt] forBarMetrics:UIBarMetricsCompactPrompt];
    
    //frame
    CGRect frame = self.frame;
    if (containerView) {
        CGRect (^convertRectToViewOrWindowBlock)(UIView *fromView, CGRect rect, UIView *view) = ^(UIView *fromView, CGRect rect, UIView *view){
            if (!view) {
                if ([fromView isKindOfClass:[UIWindow class]]) {
                    return [((UIWindow *)fromView) convertRect:rect toWindow:nil];
                } else {
                    return [fromView convertRect:rect toView:nil];
                }
            }
            
            UIWindow *from = [fromView isKindOfClass:[UIWindow class]] ? (id)fromView : fromView.window;
            UIWindow *to = [view isKindOfClass:[UIWindow class]] ? (id)view : view.window;
            if (!from || !to) return [fromView convertRect:rect toView:view];
            if (from == to) return [fromView convertRect:rect toView:view];
            rect = [fromView convertRect:rect toView:from];
            rect = [to convertRect:rect fromWindow:from];
            rect = [view convertRect:rect fromView:to];
            return rect;
        };
        
        frame = convertRectToViewOrWindowBlock(self.superview,self.frame,containerView);
    }
    
    if ([UIDevice currentDevice].systemVersion.doubleValue<8.3f) {
        //below iOS8.3, if only use barTintColor, maybe trigger a bug that display a white line leftside.
        //We fix it below
        if (!self.ml_currentBackgroundImage) {
            CGFloat offset = 1.0f/[UIScreen mainScreen].scale;
            frame.origin.x -= offset;
            frame.size.width += offset*2;
        }
    }
    
    //in iOS10, if barTintColor is nil, then the ml_backgroundShadowView would be nil.
    //It's not our expectation, so we set non-nil value first to ensure the ml_backgroundShadowView created inside.
    bar.barTintColor = [UIColor blackColor];
    bar.frame = frame;
    bar.barTintColor = self.barTintColor;
    
    CGRect backgroundViewFrame = self.ml_backgroundView.frame;
    backgroundViewFrame.size.width = bar.frame.size.width;
    bar.ml_backgroundView.frame = backgroundViewFrame;
    
    //alpha
    bar.alpha = self.alpha;
    bar.ml_backgroundView.alpha = self.ml_backgroundView.alpha;
    
    //shadow image view alpha and hidden
    bar.ml_backgroundShadowView.alpha = self.ml_backgroundShadowView.alpha;
    bar.ml_backgroundShadowView.hidden = self.ml_backgroundShadowView.hidden;
    
    //_barPosition is important
    @try {
    //    NSLog(@"%@:%@",@"_barPosition",[@"_barPosition" mlnbt_EncryptString]);
        [bar setValue:@(self.barPosition) forKey:[@"K2WupyOip2y0nJ9h" mlnbt_DecryptString]];
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
        self.ml_backgroundShadowView.alpha != navigationBar.ml_backgroundShadowView.alpha||
        self.ml_backgroundShadowView.hidden != navigationBar.ml_backgroundShadowView.hidden
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

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        BOOL valid = mlnbt_exchangeInstanceMethod(self, @selector(hitTest:withEvent:), @selector(_mlnbt_hitTest:withEvent:));
        if (!valid) {
            NSLog(@"Hook on UINavigationBar (MLNavigationBarTransition) is not valid now! Please check it.");
        }
    });
}

- (UIView *)_mlnbt_hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *r = [self _mlnbt_hitTest:point withEvent:event];
    if (self.ml_backgroundView.alpha==0.0f) {
        if ([r isEqual:self]||[r isEqual:self.ml_backgroundView]) {
            //Because although touching back button area, the r is always the bar. so we need do extra checking.
            @try {
                if ([self _hasBackButton]&&[self _shouldPopForTouchAtPoint:point]) {
                    return r;
                }
            } @catch (NSException *exception) {
                NSLog(@"_hasBackButton or _shouldPopForTouchAtPoint of UINavigationBar is not exist now!");
                return nil;
            }
            
            return nil;
        }
    }
    return r;
}

@end
