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
        if (!valid) {
            NSLog(@"UINavigationController (MLNavigationBarTransition) is not valid now! Please check it.");
        }
        NSAssert(valid, @"UINavigationController (MLNavigationBarTransition) is not valid now! Please check it.");
#pragma clang diagnostic pop
    });
}

#pragma mark - addition properties

MLNBT_SYNTH_DYNAMIC_PROPERTY_OBJECT(_mlnbt_transitionFromBar, set_mlnbt_transitionFromBar:, RETAIN_NONATOMIC, UINavigationBar *)
MLNBT_SYNTH_DYNAMIC_PROPERTY_OBJECT(_mlnbt_transitionToBar, set_mlnbt_transitionToBar:, RETAIN_NONATOMIC, UINavigationBar *)

#pragma mark - disable navigationBarHidden
- (void)_mlnbt_setNavigationBarHidden:(BOOL)navigationBarHidden {
    NSAssert(NO, @"Please dont use `navigationBarHidden`,there are some bugs with it. You can use `.navigationBar.ml_backgroundView.alpha = 0.0f;`");
    [self _mlnbt_setNavigationBarHidden:navigationBarHidden];
}

- (void)_mlnbt_setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated {
    NSAssert(NO, @"Please dont use `navigationBarHidden`,there are some bugs with it. You can use `.navigationBar.ml_backgroundView.alpha = 0.0f;`");
    [self _mlnbt_setNavigationBarHidden:hidden animated:animated];
}

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
                
                UIImageView *backIndicatorSnapshotView = [[UIImageView alloc]initWithImage:_mlnbt_snapshotWithView(backIndicatorView,NO)];
                backIndicatorSnapshotView.alpha = backIndicatorView.alpha;
                
                backIndicatorSnapshotView.frame = backIndicatorView.frame;
                [backIndicatorView.superview addSubview:backIndicatorSnapshotView];
                
                [self.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                    backIndicatorSnapshotView.alpha = 0.0f;
                } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                    [backIndicatorSnapshotView removeFromSuperview];
                }];
            }
            
        }
    }
    
    [self _mlnbt_startCustomTransition:arg1];
    
    if (fromTintColor) {
        //change backButtonLabel textColor to fromBar's tintColor
        self.navigationBar.ml_backButtonLabel.textColor = fromTintColor;
    }
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
        if (!valid) {
            NSLog(@"NSObject(MLNavigationBarTransition) is not valid now! Please check it.");
        }
        NSAssert(valid, @"NSObject(MLNavigationBarTransition) is not valid now! Please check it.");
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
        NSAssert(NO, @"_mlnbt_shadowBorderViewForUINavigationParallaxTransition is not valid");
    }
    return nil;
}

- (UIView*)_mlnbt_containerFromViewForUINavigationParallaxTransition {
    @try {
     //   NSLog(@"%@:%@",@"containerFromView",[@"containerFromView" mlnbt_EncryptString]);
        return [self valueForKey:[@"L29hqTScozIlEaWioIMcMKp=" mlnbt_DecryptString]];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
        NSAssert(NO, @"`containerFromView` key of UINavigationParallaxTransition is not valid");
    }
    return nil;
}

- (UIView*)_mlnbt_containerToViewForUINavigationParallaxTransition {
    @try {
    //    NSLog(@"%@:%@",@"containerToView",[@"containerToView" mlnbt_EncryptString]);
        return [self valueForKey:[@"L29hqTScozIlIT9JnJI3" mlnbt_DecryptString]];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
        NSAssert(NO, @"`containerToView` key of UINavigationParallaxTransition is not valid");
    }
    return nil;
}

- (id<UIViewControllerContextTransitioning>)_mlnbt_transitionContextForUINavigationParallaxTransition {
    @try {
    //    NSLog(@"%@:%@",@"transitionContext",[@"transitionContext" mlnbt_EncryptString]);
        return [self valueForKey:[@"qUWuoaAcqTyioxAioaEyrUD=" mlnbt_DecryptString]];
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
        
        [containerFromView addSubview:navigationController._mlnbt_transitionFromBar];
        [containerToView addSubview:navigationController._mlnbt_transitionToBar];
    }else{
        //if alpha not equal with 1.0f, show long shadow border
        if (navigationController._mlnbt_transitionFromBar.ml_backgroundView.alpha*navigationController._mlnbt_transitionFromBar.alpha>=0.999f) {
            shortShadowBorder = YES;
        }
        
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
    [self _mlnbt_animationEnded:transitionCompleted];
    
    id<UIViewControllerContextTransitioning> transitionContext = [self _mlnbt_transitionContextForUINavigationParallaxTransition];
    if (!transitionContext) {
        return;
    }
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UINavigationController *navigationController = toVC.navigationController;
    if (!navigationController) {
        navigationController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].navigationController;
    }
    
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
