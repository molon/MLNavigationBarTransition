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

MLNBT_SYNTH_DUMMY_CLASS(UINavigationController_MLNavigationBarTransition)

#pragma mark - UINavigationController(MLNavigationBarTransition)

@interface UINavigationController()

@property (nonatomic, strong) UINavigationBar *_mlnbt_transitionFromBar;
@property (nonatomic, strong) UINavigationBar *_mlnbt_transitionToBar;

@end

@implementation UINavigationController (MLNavigationBarTransition)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        BOOL valid = mlnbt_exchangeInstanceMethod(self, @selector(setNavigationBarHidden:), @selector(_mlnbt_setNavigationBarHidden:))&&
        mlnbt_exchangeInstanceMethod(self, @selector(setNavigationBarHidden:animated:), @selector(_mlnbt_setNavigationBarHidden:animated:))&&
        mlnbt_exchangeInstanceMethod(self, @selector(_startCustomTransition:), @selector(_mlnbt_startCustomTransition:));
        NSAssert(valid, @"UINavigationController (MLNavigationBarTransition) is not valid now! Please check it.");
#pragma clang diagnostic pop
    });
}

#pragma mark - addition properties

MLNBT_SYNTH_DYNAMIC_PROPERTY_OBJECT(_mlnbt_transitionFromBar, set_mlnbt_transitionFromBar:, RETAIN_NONATOMIC, UINavigationBar *)
MLNBT_SYNTH_DYNAMIC_PROPERTY_OBJECT(_mlnbt_transitionToBar, set_mlnbt_transitionToBar:, RETAIN_NONATOMIC, UINavigationBar *)

#pragma mark - disable navigationBarHidden
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
        UIView *containerView = [self.transitionCoordinator containerView];
        if (containerView) {
            UINavigationBar *fromBar = [self.navigationBar ml_replicantBarOfSameBackgroundEffect];
            //adjust frame
            fromBar.frame = [self.navigationBar.superview convertRect:self.navigationBar.frame toView:containerView];
            self._mlnbt_transitionFromBar = fromBar;
        }
    }
    
    [self _mlnbt_startCustomTransition:arg1];
}

@end

#pragma mark - NSObject(MLNavigationBarTransition)

@interface NSObject(MLNavigationBarTransition)
- (UIView*)_mlnbt_containerFromViewForUINavigationParallaxTransition;
- (UIView*)_mlnbt_containerToViewForUINavigationParallaxTransition;
@end

@implementation NSObject(MLNavigationBarTransition)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = NSClassFromString(@"_UINavigationParallaxTransition");
        
        BOOL valid = mlnbt_exchangeInstanceMethod(cls,@selector(animateTransition:),@selector(_mlnbt_animateTransition:))&&
        mlnbt_exchangeInstanceMethod(cls,@selector(animationEnded:),@selector(_mlnbt_animationEnded:));
        NSAssert(valid, @"NSObject(MLNavigationBarTransition) is not valid now! Please check it.");
    });
}

#pragma mark - helper
- (UIView*)_mlnbt_shadowBorderViewForUINavigationParallaxTransition {
    @try {
        UIView *dimmingView = [self valueForKey:@"_borderDimmingView"];
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
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
        NSAssert(NO, @"_mlnbt_shadowBorderViewForUINavigationParallaxTransition is not valid");
    }
    return nil;
}

- (UIView*)_mlnbt_containerFromViewForUINavigationParallaxTransition {
    @try {
        return [self valueForKey:@"containerFromView"];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
        NSAssert(NO, @"`containerFromView` key of UINavigationParallaxTransition is not valid");
    }
    return nil;
}

- (UIView*)_mlnbt_containerToViewForUINavigationParallaxTransition {
    @try {
        return [self valueForKey:@"containerToView"];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
        NSAssert(NO, @"`containerToView` key of UINavigationParallaxTransition is not valid");
    }
    return nil;
}

- (id<UIViewControllerContextTransitioning>)_mlnbt_transitionContextForUINavigationParallaxTransition {
    @try {
        return [self valueForKey:@"transitionContext"];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
        NSAssert(NO, @"`transitionContext` key of UINavigationParallaxTransition is not valid");
    }
    return nil;
}

#pragma mark - hook
- (void)_mlnbt_animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UINavigationController *navigationController = fromVC.navigationController;
    //if no _mlnbt_transitionFromBar, dont need continue
    if (!navigationController||!navigationController._mlnbt_transitionFromBar||![navigationController.transitionCoordinator isAnimated]) {
        navigationController._mlnbt_transitionFromBar = nil;
        [self _mlnbt_animateTransition:transitionContext];
        return;
    }
    
    //shadow border should be short or not
    BOOL shortShadowBorder = NO;
    
    //transitionToBar, the method `viewWillAppear` of toVC is excuted now.
    navigationController._mlnbt_transitionToBar = [navigationController.navigationBar ml_replicantBarOfSameBackgroundEffect];
    
    //to bar
    UIView *containerView = [transitionContext containerView];
    if (containerView) {
        UINavigationBar *toBar = [navigationController.navigationBar ml_replicantBarOfSameBackgroundEffect];;
        //adjust frame
        toBar.frame = [navigationController.navigationBar.superview convertRect:navigationController.navigationBar.frame toView:containerView];
        navigationController._mlnbt_transitionToBar = toBar;
    }
    
    //containerViews
    UIView *containerFromView = [self _mlnbt_containerFromViewForUINavigationParallaxTransition];
    UIView *containerToView = [self _mlnbt_containerToViewForUINavigationParallaxTransition];
    if (navigationController._mlnbt_transitionToBar&&![navigationController._mlnbt_transitionFromBar ml_isSameBackgroundEffectToNavigationBar:navigationController._mlnbt_transitionToBar]&&containerFromView&&containerToView) {
        
        navigationController.navigationBar.ml_backgroundView.hidden = YES;
    
        [containerFromView addSubview:navigationController._mlnbt_transitionFromBar];
        [containerToView addSubview:navigationController._mlnbt_transitionToBar];
    }else{
        shortShadowBorder = YES;
        
        navigationController._mlnbt_transitionFromBar = nil;
        navigationController._mlnbt_transitionToBar = nil;
    }
    
    [self _mlnbt_animateTransition:transitionContext];
    
    UIView *shadowBorderView = [self _mlnbt_shadowBorderViewForUINavigationParallaxTransition];
    if (shortShadowBorder) {
        CGRect frame = [navigationController.navigationBar.superview convertRect:navigationController.navigationBar.frame toView:shadowBorderView.superview];
        //ensure display below naivigationBar
        shadowBorderView.frame = CGRectMake(shadowBorderView.frame.origin.x, frame.origin.y+frame.size.height, shadowBorderView.frame.size.width, shadowBorderView.frame.size.height);
    }else{
        CGPoint origin = [shadowBorderView convertPoint:CGPointZero toView:containerToView];
        shadowBorderView.frame = CGRectMake(shadowBorderView.frame.origin.x, shadowBorderView.frame.origin.y-origin.y, shadowBorderView.frame.size.width, shadowBorderView.frame.size.height+origin.y);
    }
}

- (void)_mlnbt_animationEnded:(BOOL)transitionCompleted {
    id<UIViewControllerContextTransitioning> transitionContext = [self _mlnbt_transitionContextForUINavigationParallaxTransition];
    if (!transitionContext) {
        [self _mlnbt_animationEnded:transitionCompleted];
        return;
    }
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UINavigationController *navigationController = toVC.navigationController;
    if (!navigationController) {
        navigationController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].navigationController;
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
