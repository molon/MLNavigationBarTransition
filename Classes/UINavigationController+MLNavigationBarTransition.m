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
#import "NSString+MLNavigationBarTransition_Encrypt.h"

MLNBT_SYNTH_DUMMY_CLASS(UINavigationController_MLNavigationBarTransition)

static inline UIImage *_mlnbt_snapshotWithView(UIView *view, BOOL afterUpdates) {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:afterUpdates];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}

#pragma mark - UIView(_MLNavigationBarTransition)
@interface UIView (_MLNavigationBarTransition)

@property (nonatomic, assign) BOOL _mlnbt_disableSettingHidden;

@end

@implementation UIView (_MLNavigationBarTransition)

MLNBT_SYNTH_DYNAMIC_PROPERTY_CTYPE(_mlnbt_disableSettingHidden, set_mlnbt_disableSettingHidden:, BOOL)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mlnbt_exchangeInstanceMethod(self, @selector(setHidden:), @selector(_mlnbt_setHidden:));
    });
}

- (void)_mlnbt_setHidden:(BOOL)hidden {
    if (self._mlnbt_disableSettingHidden) {
        return;
    }
    
    [self _mlnbt_setHidden:hidden];
}

@end

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
//          NSLog(@"%@:%@",@"_startCustomTransition:",[@"_startCustomTransition:" mlnbt_EncryptString]);
        BOOL valid = /*mlnbt_exchangeInstanceMethod(self, @selector(setNavigationBarHidden:), @selector(_mlnbt_setNavigationBarHidden:))&&
        mlnbt_exchangeInstanceMethod(self, @selector(setNavigationBarHidden:animated:), @selector(_mlnbt_setNavigationBarHidden:animated:))&&*/
        mlnbt_exchangeInstanceMethod(self,NSSelectorFromString([@"K3A0LKW0D3ImqT9gIUWuoaAcqTyiowb=" mlnbt_DecryptString]), @selector(_mlnbt_startCustomTransition:));
        MLNBT_NSASSERT(valid, @"UINavigationController (MLNavigationBarTransition) is not valid now!");
#pragma clang diagnostic pop
    });
}

#pragma mark - addition properties

MLNBT_SYNTH_DYNAMIC_PROPERTY_OBJECT(_mlnbt_transitionFromBar, set_mlnbt_transitionFromBar:, RETAIN_NONATOMIC, UINavigationBar *)
MLNBT_SYNTH_DYNAMIC_PROPERTY_OBJECT(_mlnbt_transitionToBar, set_mlnbt_transitionToBar:, RETAIN_NONATOMIC, UINavigationBar *)

#pragma mark - disable navigationBarHidden
//- (void)_mlnbt_setNavigationBarHidden:(BOOL)navigationBarHidden {
//    NSLog(@"Please dont use `navigationBarHidden`,there are some bugs with it in iOS SDK. You can use `.navigationBar.ml_backgroundAlpha = 0.0f;`");
//    [self _mlnbt_setNavigationBarHidden:navigationBarHidden];
//}
//
//- (void)_mlnbt_setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated {
//    NSLog(@"Please dont use `navigationBarHidden`,there are some bugs with it in iOS SDK. You can use `.navigationBar.ml_backgroundAlpha = 0.0f;`");
//    [self _mlnbt_setNavigationBarHidden:hidden animated:animated];
//}

- (void)_mlnbt_startCustomTransition:(id)arg1 {
    UIColor *fromTintColor = nil;
    
    if ([self.transitionCoordinator isAnimated]) {
        UIView *containerView = [self.transitionCoordinator containerView];
        if (containerView) {
            self._mlnbt_transitionFromBar = [self.navigationBar ml_replicantBarOfSameBackgroundEffectWithContainerView:containerView];
            
            //maybe _mlnbt_transitionFromBar will be nil in `_mlnbt_startCustomTransition`, so we store it
            fromTintColor = self._mlnbt_transitionFromBar.tintColor;
            
            //back indicator fade out animation
            UIView *backIndicatorView = self.navigationBar.ml_backIndicatorView;
            if (backIndicatorView) {
                //Because `snapshotViewAfterScreenUpdates:` has some bugs, we abandon it
//                UIView *backIndicatorSnapshotView = [backIndicatorView snapshotViewAfterScreenUpdates:NO];
                UIImage *snapshot = _mlnbt_snapshotWithView(backIndicatorView,NO);
                if (snapshot) {
                    UIImageView *backIndicatorSnapshotView = [[UIImageView alloc]initWithImage:snapshot];
                    backIndicatorSnapshotView.alpha = backIndicatorView.alpha;
                    
                    backIndicatorSnapshotView.frame = backIndicatorView.bounds;
                    [backIndicatorView addSubview:backIndicatorSnapshotView];
                    
                    [self.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                        backIndicatorSnapshotView.alpha = 0.0f;
                    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                        [backIndicatorSnapshotView removeFromSuperview];
                    }];
                }
            }
            
            //backButtonLabel fade out animation
            UILabel *backButtonLabel = self.navigationBar.ml_backButtonLabel;
            if (backButtonLabel) {
                backButtonLabel.textColor = fromTintColor;
                
                UIImage *snapshot = _mlnbt_snapshotWithView(backButtonLabel,NO);
                if (snapshot) {
                    UIImageView *backButtonLabelSnapshotView = [[UIImageView alloc]initWithImage:snapshot];
                    backButtonLabelSnapshotView.alpha = backButtonLabel.alpha;
                    
                    backButtonLabelSnapshotView.frame = backButtonLabel.bounds;
                    [backButtonLabel addSubview:backButtonLabelSnapshotView];
                    
                    [self.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                        backButtonLabelSnapshotView.alpha = 0.0f;
                    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                        [backButtonLabelSnapshotView removeFromSuperview];
                    }];
                }
            }
        }
    }
    
    [self _mlnbt_startCustomTransition:arg1];
}

@end

#pragma mark - NSObject(MLNavigationBarTransition)

@interface NSObject(MLNavigationBarTransition)
@end

@implementation NSObject(MLNavigationBarTransition)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      //  NSLog(@"%@:%@",@"_UINavigationParallaxTransition",[@"_UINavigationParallaxTransition" mlnbt_EncryptString]);
        Class cls = NSClassFromString([@"K1IWGzS2nJquqTyioyOupzSfoTS4IUWuoaAcqTyiot==" mlnbt_DecryptString]);
        
        BOOL valid = mlnbt_exchangeInstanceMethod(cls,@selector(animateTransition:),@selector(_mlnbt_animateTransition:))&&
        mlnbt_exchangeInstanceMethod(cls,@selector(animationEnded:),@selector(_mlnbt_animationEnded:));
        MLNBT_NSASSERT(valid, @"NSObject(MLNavigationBarTransition) is not valid now! Please check it.");
    });
}

#pragma mark - helper
- (UIView*)_mlnbt_shadowBorderViewForUINavigationParallaxTransition {
    @try {
        // NSLog(@"%@:%@",@"_borderDimmingView",[@"_borderDimmingView" mlnbt_EncryptString]);
        UIView *dimmingView = [self valueForKey:[@"K2WipzEypxEcoJ1cozqJnJI3" mlnbt_DecryptString]];
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
        MLNBT_NSASSERT(NO, @"_mlnbt_shadowBorderViewForUINavigationParallaxTransition is not valid");
    }
    return nil;
}

- (UIView*)_mlnbt_containerFromViewForUINavigationParallaxTransition {
    @try {
     //   NSLog(@"%@:%@",@"containerFromView",[@"containerFromView" mlnbt_EncryptString]);
        return [self valueForKey:[@"L29hqTScozIlEaWioIMcMKp=" mlnbt_DecryptString]];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
        MLNBT_NSASSERT(NO, @"`containerFromView` key of UINavigationParallaxTransition is not valid");
    }
    return nil;
}

- (UIView*)_mlnbt_containerToViewForUINavigationParallaxTransition {
    @try {
    //    NSLog(@"%@:%@",@"containerToView",[@"containerToView" mlnbt_EncryptString]);
        return [self valueForKey:[@"L29hqTScozIlIT9JnJI3" mlnbt_DecryptString]];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
        MLNBT_NSASSERT(NO, @"`containerToView` key of UINavigationParallaxTransition is not valid");
    }
    return nil;
}

- (id<UIViewControllerContextTransitioning>)_mlnbt_transitionContextForUINavigationParallaxTransition {
    @try {
    //    NSLog(@"%@:%@",@"transitionContext",[@"transitionContext" mlnbt_EncryptString]);
        return [self valueForKey:[@"qUWuoaAcqTyioxAioaEyrUD=" mlnbt_DecryptString]];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
        MLNBT_NSASSERT(NO, @"`transitionContext` key of UINavigationParallaxTransition is not valid");
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
    
    //transitionToBar, `viewWillAppear` of toVC has excuted now.
    //to bar
    UIView *containerView = [transitionContext containerView];
    if (containerView) {
        navigationController._mlnbt_transitionToBar = [navigationController.navigationBar ml_replicantBarOfSameBackgroundEffectWithContainerView:containerView];
    }
    
    //containerViews
    UIView *containerFromView = [self _mlnbt_containerFromViewForUINavigationParallaxTransition];
    UIView *containerToView = [self _mlnbt_containerToViewForUINavigationParallaxTransition];
    
    //if cant get these, just return
    if (!navigationController._mlnbt_transitionToBar||!containerFromView||!containerToView) {
        navigationController._mlnbt_transitionFromBar = nil;
        navigationController._mlnbt_transitionToBar = nil;
        
        [self _mlnbt_animateTransition:transitionContext];
        return;
    }
    
    //shadow border should be short or not
    BOOL shortShadowBorder = NO;
    
    BOOL sameBackgroundEffect = [navigationController._mlnbt_transitionFromBar ml_isSameBackgroundEffectToNavigationBar:navigationController._mlnbt_transitionToBar];
    if (!sameBackgroundEffect) {
        navigationController.navigationBar.ml_backgroundView.hidden = YES;
        navigationController.navigationBar.ml_backgroundView._mlnbt_disableSettingHidden = YES;
        
        [containerFromView addSubview:navigationController._mlnbt_transitionFromBar];
        [containerToView addSubview:navigationController._mlnbt_transitionToBar];
    }else{
        //if alpha not equal with 1.0f, show long shadow border
        if (navigationController._mlnbt_transitionFromBar.ml_backgroundAlpha*navigationController._mlnbt_transitionFromBar.alpha>=0.999f) {
            shortShadowBorder = YES;
        }
        
        navigationController._mlnbt_transitionFromBar = nil;
        navigationController._mlnbt_transitionToBar = nil;
    }
    
    [self _mlnbt_animateTransition:transitionContext];
    
    if (!shortShadowBorder) {
        UIView *shadowBorderView = [self _mlnbt_shadowBorderViewForUINavigationParallaxTransition];
        CGPoint origin = [shadowBorderView convertPoint:CGPointZero toView:containerToView];
        shadowBorderView.frame = CGRectMake(shadowBorderView.frame.origin.x, shadowBorderView.frame.origin.y-origin.y, shadowBorderView.frame.size.width, shadowBorderView.frame.size.height+origin.y);
    }
}

- (void)_mlnbt_animationEnded:(BOOL)transitionCompleted {
    [self _mlnbt_animationEnded:transitionCompleted];
    
    UINavigationController *navigationController = nil;
    
    id<UIViewControllerContextTransitioning> transitionContext = [self _mlnbt_transitionContextForUINavigationParallaxTransition];
    if (transitionContext) {
        UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        navigationController = toVC.navigationController;
        if (!navigationController) {
            navigationController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].navigationController;
        }
    }
    
    if (!navigationController) {
        return;
    }
    navigationController.navigationBar.ml_backgroundView._mlnbt_disableSettingHidden = NO;
    
    //fix a bug below 8.3
    if (navigationController.navigationBar.ml_backgroundView.hidden) {
        if (!transitionCompleted&&[UIDevice currentDevice].systemVersion.doubleValue<8.3f) {
            UIColor *barTintColor = navigationController.navigationBar.barTintColor;
            navigationController.navigationBar.barTintColor = nil;
            navigationController.navigationBar.barTintColor = barTintColor;
        }
        
        navigationController.navigationBar.ml_backgroundView.hidden = NO;
    }
    
    [navigationController._mlnbt_transitionFromBar removeFromSuperview];
    [navigationController._mlnbt_transitionToBar removeFromSuperview];
    navigationController._mlnbt_transitionFromBar = nil;
    navigationController._mlnbt_transitionToBar = nil;
}

@end
