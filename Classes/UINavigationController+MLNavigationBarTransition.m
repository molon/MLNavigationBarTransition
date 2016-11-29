//
//  UINavigationController+MLNavigationBarTransition.m
//  MLNavigationBarTransition
//
//  Created by molon on 2016/11/28.
//  Copyright © 2016年 molon. All rights reserved.
//

#import "UINavigationController+MLNavigationBarTransition.h"
#import "MLNavigationBarTransitionDefine.h"
#import "UINavigationBar+MLNavigationBarTransition.h"

#import <MLKit.h>

@interface UINavigationController (_MLNavigationBarTransition_Helper)

- (void)_startCustomTransition:(id)arg1;

@end

@interface UINavigationController()

@property (nonatomic, strong) UINavigationBar *_mlnbt_transitionFromBar;
@property (nonatomic, strong) UINavigationBar *_mlnbt_transitionToBar;

@property (nonatomic, strong, readonly) UIView *_mlnbt_shadowBorderView;

@end

@implementation UINavigationController (MLNavigationBarTransition)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mlnbt_exchangeInstanceMethod(self, @selector(setNavigationBarHidden:), @selector(_mlnbt_setNavigationBarHidden:));
        mlnbt_exchangeInstanceMethod(self, @selector(setNavigationBarHidden:animated:), @selector(_mlnbt_setNavigationBarHidden:animated:));
        mlnbt_exchangeInstanceMethod(self, @selector(_startCustomTransition:), @selector(_mlnbt_startCustomTransition:));
    });
}

#pragma mark - properties
SYNTH_DYNAMIC_PROPERTY_OBJECT(_mlnbt_transitionFromBar, set_mlnbt_transitionFromBar:, RETAIN_NONATOMIC, UINavigationBar *)
SYNTH_DYNAMIC_PROPERTY_OBJECT(_mlnbt_transitionToBar, set_mlnbt_transitionToBar:, RETAIN_NONATOMIC, UINavigationBar *)

#warning 这个应该扔到下面去
- (UIView*)_mlnbt_shadowBorderView {
    @try {
        id transitionController = [self valueForKey:@"__transitionController"];
        if (transitionController) {
            UIView *dimmingView = [transitionController valueForKey:@"_borderDimmingView"];
            if (dimmingView) {
                UIImageView *imageView = nil;
                for (UIView *v in dimmingView.subviews) {
                    if ([v isKindOfClass:[UIImageView class]]) {
                        imageView = (UIImageView *)v;
                        break;
                    }
                }
                return imageView;
            }
        }
    } @catch (NSException *exception) {
        DDLogError(@"%@",exception);
    }
    return nil;
}

#pragma mark - disable navigationBarHidden
#warning 考虑直接去实现隐藏背景？
- (void)_mlnbt_setNavigationBarHidden:(BOOL)navigationBarHidden {
    NSAssert(NO, @"Please dont use `navigationBarHidden`,there are some bugs with it");
    [self _mlnbt_setNavigationBarHidden:navigationBarHidden];
}

- (void)_mlnbt_setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated {
    NSAssert(NO, @"Please dont use `navigationBarHidden`,there are some bugs with it");
    [self _mlnbt_setNavigationBarHidden:hidden animated:animated];
}

- (void)_mlnbt_startCustomTransition:(id)arg1 {
    if ([self.transitionCoordinator isAnimated]) {
        self._mlnbt_transitionFromBar = [self.navigationBar ml_replicantBarOfSameBackgroundEffect];
    }
    
    [self _mlnbt_startCustomTransition:arg1];
}

@end

@interface NSObject(MLNavigationBarTransition)

@end

@implementation NSObject(MLNavigationBarTransition)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = NSClassFromString(@"_UINavigationParallaxTransition");
        
        BOOL valid = cls&&
        [cls instancesRespondToSelector:@selector(animateTransition:)]&&
        [cls instancesRespondToSelector:@selector(animationEnded:)];
#warning 可以检查的还有其他的
        NSAssert(valid, @"MLNavigationBarTransition is not valid now! Please check it.");
        if (valid) {
            mlnbt_exchangeInstanceMethod(cls,@selector(animateTransition:),@selector(_mlnbt_animateTransition:));
            mlnbt_exchangeInstanceMethod(cls,@selector(animationEnded:),@selector(_mlnbt_animationEnded:));
        }
    });
}

- (void)_mlnbt_animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UINavigationController *navigationController = fromVC.navigationController;
    if (!navigationController) {
        [self _mlnbt_animateTransition:transitionContext];
        return;
    }
    
    //shadow border should be short or not
    BOOL shortShadowBorder = NO;
    
    //transitionToBar, the method `viewWillAppear` of toVC is excuted now.
    navigationController._mlnbt_transitionToBar = [navigationController.navigationBar ml_replicantBarOfSameBackgroundEffect];
    
    //removeFromSuperview first
    [navigationController._mlnbt_transitionFromBar removeFromSuperview];
    [navigationController._mlnbt_transitionToBar removeFromSuperview];
    
    if (![navigationController._mlnbt_transitionFromBar ml_isSameBackgroundEffectToNavigationBar:navigationController._mlnbt_transitionToBar]) {
        
        navigationController.navigationBar.ml_backgroundView.hidden = YES;
        
#warning 需要验证这个key，而且这两者的frame一开始那样设置不太好
        UIView *containerFromView = [self valueForKey:@"containerFromView"];
        UIView *containerToView = [self valueForKey:@"containerToView"];
        [containerFromView addSubview:navigationController._mlnbt_transitionFromBar];
        [containerToView addSubview:navigationController._mlnbt_transitionToBar];
    }else{
        shortShadowBorder = YES;
        
        navigationController._mlnbt_transitionFromBar = nil;
        navigationController._mlnbt_transitionToBar = nil;
    }
    
    [self _mlnbt_animateTransition:transitionContext];
    
    UIView *shadowBorderView = navigationController._mlnbt_shadowBorderView;
    if (shortShadowBorder) {
#warning 这个也不合适，要根据在上面的那个containerView里存储的bar的bottom来算。
        shadowBorderView.top = navigationController.navigationBar.bottom;
    }else{
        CGPoint origin = [shadowBorderView convertPoint:CGPointZero toView:transitionContext.containerView];
        shadowBorderView.top -= origin.y;
        shadowBorderView.height += origin.y;
    }
}

- (void)_mlnbt_animationEnded:(BOOL)transitionCompleted {
    UIViewController *toVC = [[self valueForKey:@"transitionContext"] viewControllerForKey:UITransitionContextToViewControllerKey];
    UINavigationController *navigationController = toVC.navigationController;
    if (!navigationController) {
        navigationController = [[self valueForKey:@"transitionContext"] viewControllerForKey:UITransitionContextFromViewControllerKey].navigationController;
    }
    
    void (^resetBlock)() = ^{
        navigationController.navigationBar.ml_backgroundView.hidden = NO;
        
        [navigationController._mlnbt_transitionFromBar removeFromSuperview];
        [navigationController._mlnbt_transitionToBar removeFromSuperview];
        navigationController._mlnbt_transitionFromBar = nil;
        navigationController._mlnbt_transitionToBar = nil;
    };
    
#warning iOS7的闪烁BUG还没想到好法子
    resetBlock();
    
    [self _mlnbt_animationEnded:transitionCompleted];
}

@end
