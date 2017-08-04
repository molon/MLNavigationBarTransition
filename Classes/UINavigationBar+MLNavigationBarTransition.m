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

@interface NSObject(_MLNavigationBarTransition)

@end

@implementation NSObject(_MLNavigationBarTransition)

#define MLNBT_INIT_INV(_last_arg_, _return_) \
NSMethodSignature * sig = [self methodSignatureForSelector:sel]; \
if (!sig) { [self doesNotRecognizeSelector:sel]; return _return_; } \
NSInvocation *inv = [NSInvocation invocationWithMethodSignature:sig]; \
if (!inv) { [self doesNotRecognizeSelector:sel]; return _return_; } \
[inv setTarget:self]; \
[inv setSelector:sel]; \
va_list args; \
va_start(args, _last_arg_); \
[NSObject mlnbt_setInv:inv withSig:sig andArgs:args]; \
va_end(args);

- (id)mlnbt_performSelectorWithArgs:(SEL)sel, ...{
    MLNBT_INIT_INV(sel, nil);
    [inv invoke];
    return [NSObject mlnbt_getReturnFromInv:inv withSig:sig];
}

#undef MLNBT_INIT_INV

+ (id)mlnbt_getReturnFromInv:(NSInvocation *)inv withSig:(NSMethodSignature *)sig {
    NSUInteger length = [sig methodReturnLength];
    if (length == 0) return nil;
    
    char *type = (char *)[sig methodReturnType];
    while (*type == 'r' || // const
           *type == 'n' || // in
           *type == 'N' || // inout
           *type == 'o' || // out
           *type == 'O' || // bycopy
           *type == 'R' || // byref
           *type == 'V') { // oneway
        type++; // cutoff useless prefix
    }
    
#define return_with_number(_type_) \
do { \
_type_ ret; \
[inv getReturnValue:&ret]; \
return @(ret); \
} while (0)
    
    switch (*type) {
        case 'v': return nil; // void
        case 'B': return_with_number(bool);
        case 'c': return_with_number(char);
        case 'C': return_with_number(unsigned char);
        case 's': return_with_number(short);
        case 'S': return_with_number(unsigned short);
        case 'i': return_with_number(int);
        case 'I': return_with_number(unsigned int);
        case 'l': return_with_number(int);
        case 'L': return_with_number(unsigned int);
        case 'q': return_with_number(long long);
        case 'Q': return_with_number(unsigned long long);
        case 'f': return_with_number(float);
        case 'd': return_with_number(double);
        case 'D': { // long double
            long double ret;
            [inv getReturnValue:&ret];
            return [NSNumber numberWithDouble:ret];
        };
            
        case '@': { // id
            id ret = nil;
            [inv getReturnValue:&ret];
            return ret;
        };
            
        case '#': { // Class
            Class ret = nil;
            [inv getReturnValue:&ret];
            return ret;
        };
            
        default: { // struct / union / SEL / void* / unknown
            const char *objCType = [sig methodReturnType];
            char *buf = calloc(1, length);
            if (!buf) return nil;
            [inv getReturnValue:buf];
            NSValue *value = [NSValue valueWithBytes:buf objCType:objCType];
            free(buf);
            return value;
        };
    }
#undef return_with_number
}

+ (void)mlnbt_setInv:(NSInvocation *)inv withSig:(NSMethodSignature *)sig andArgs:(va_list)args {
    NSUInteger count = [sig numberOfArguments];
    for (int index = 2; index < count; index++) {
        char *type = (char *)[sig getArgumentTypeAtIndex:index];
        while (*type == 'r' || // const
               *type == 'n' || // in
               *type == 'N' || // inout
               *type == 'o' || // out
               *type == 'O' || // bycopy
               *type == 'R' || // byref
               *type == 'V') { // oneway
            type++; // cutoff useless prefix
        }
        
        BOOL unsupportedType = NO;
        switch (*type) {
            case 'v': // 1: void
            case 'B': // 1: bool
            case 'c': // 1: char / BOOL
            case 'C': // 1: unsigned char
            case 's': // 2: short
            case 'S': // 2: unsigned short
            case 'i': // 4: int / NSInteger(32bit)
            case 'I': // 4: unsigned int / NSUInteger(32bit)
            case 'l': // 4: long(32bit)
            case 'L': // 4: unsigned long(32bit)
            { // 'char' and 'short' will be promoted to 'int'.
                int arg = va_arg(args, int);
                [inv setArgument:&arg atIndex:index];
            } break;
                
            case 'q': // 8: long long / long(64bit) / NSInteger(64bit)
            case 'Q': // 8: unsigned long long / unsigned long(64bit) / NSUInteger(64bit)
            {
                long long arg = va_arg(args, long long);
                [inv setArgument:&arg atIndex:index];
            } break;
                
            case 'f': // 4: float / CGFloat(32bit)
            { // 'float' will be promoted to 'double'.
                double arg = va_arg(args, double);
                float argf = arg;
                [inv setArgument:&argf atIndex:index];
            } break;
                
            case 'd': // 8: double / CGFloat(64bit)
            {
                double arg = va_arg(args, double);
                [inv setArgument:&arg atIndex:index];
            } break;
                
            case 'D': // 16: long double
            {
                long double arg = va_arg(args, long double);
                [inv setArgument:&arg atIndex:index];
            } break;
                
            case '*': // char *
            case '^': // pointer
            {
                void *arg = va_arg(args, void *);
                [inv setArgument:&arg atIndex:index];
            } break;
                
            case ':': // SEL
            {
                SEL arg = va_arg(args, SEL);
                [inv setArgument:&arg atIndex:index];
            } break;
                
            case '#': // Class
            {
                Class arg = va_arg(args, Class);
                [inv setArgument:&arg atIndex:index];
            } break;
                
            case '@': // id
            {
                id arg = va_arg(args, id);
                [inv setArgument:&arg atIndex:index];
            } break;
                
            case '{': // struct
            {
                if (strcmp(type, @encode(CGPoint)) == 0) {
                    CGPoint arg = va_arg(args, CGPoint);
                    [inv setArgument:&arg atIndex:index];
                } else if (strcmp(type, @encode(CGSize)) == 0) {
                    CGSize arg = va_arg(args, CGSize);
                    [inv setArgument:&arg atIndex:index];
                } else if (strcmp(type, @encode(CGRect)) == 0) {
                    CGRect arg = va_arg(args, CGRect);
                    [inv setArgument:&arg atIndex:index];
                } else if (strcmp(type, @encode(CGVector)) == 0) {
                    CGVector arg = va_arg(args, CGVector);
                    [inv setArgument:&arg atIndex:index];
                } else if (strcmp(type, @encode(CGAffineTransform)) == 0) {
                    CGAffineTransform arg = va_arg(args, CGAffineTransform);
                    [inv setArgument:&arg atIndex:index];
                } else if (strcmp(type, @encode(CATransform3D)) == 0) {
                    CATransform3D arg = va_arg(args, CATransform3D);
                    [inv setArgument:&arg atIndex:index];
                } else if (strcmp(type, @encode(NSRange)) == 0) {
                    NSRange arg = va_arg(args, NSRange);
                    [inv setArgument:&arg atIndex:index];
                } else if (strcmp(type, @encode(UIOffset)) == 0) {
                    UIOffset arg = va_arg(args, UIOffset);
                    [inv setArgument:&arg atIndex:index];
                } else if (strcmp(type, @encode(UIEdgeInsets)) == 0) {
                    UIEdgeInsets arg = va_arg(args, UIEdgeInsets);
                    [inv setArgument:&arg atIndex:index];
                } else {
                    unsupportedType = YES;
                }
            } break;
                
            case '(': // union
            {
                unsupportedType = YES;
            } break;
                
            case '[': // array
            {
                unsupportedType = YES;
            } break;
                
            default: // what?!
            {
                unsupportedType = YES;
            } break;
        }
        
        if (unsupportedType) {
            // Try with some dummy type...
            
            NSUInteger size = 0;
            NSGetSizeAndAlignment(type, &size, NULL);
            
#define case_size(_size_) \
else if (size <= 4 * _size_ ) { \
struct dummy { char tmp[4 * _size_]; }; \
struct dummy arg = va_arg(args, struct dummy); \
[inv setArgument:&arg atIndex:index]; \
}
            if (size == 0) { }
            case_size( 1) case_size( 2) case_size( 3) case_size( 4)
            case_size( 5) case_size( 6) case_size( 7) case_size( 8)
            case_size( 9) case_size(10) case_size(11) case_size(12)
            case_size(13) case_size(14) case_size(15) case_size(16)
            case_size(17) case_size(18) case_size(19) case_size(20)
            case_size(21) case_size(22) case_size(23) case_size(24)
            case_size(25) case_size(26) case_size(27) case_size(28)
            case_size(29) case_size(30) case_size(31) case_size(32)
            case_size(33) case_size(34) case_size(35) case_size(36)
            case_size(37) case_size(38) case_size(39) case_size(40)
            case_size(41) case_size(42) case_size(43) case_size(44)
            case_size(45) case_size(46) case_size(47) case_size(48)
            case_size(49) case_size(50) case_size(51) case_size(52)
            case_size(53) case_size(54) case_size(55) case_size(56)
            case_size(57) case_size(58) case_size(59) case_size(60)
            case_size(61) case_size(62) case_size(63) case_size(64)
            else {
                /*
                 Larger than 256 byte?! I don't want to deal with this stuff up...
                 Ignore this argument.
                 */
                struct dummy {char tmp;};
                for (int i = 0; i < size; i++) va_arg(args, struct dummy);
                NSLog(@"performSelectorWithArgs unsupported type:%s (%lu bytes)",
                      [sig getArgumentTypeAtIndex:index],(unsigned long)size);
            }
#undef case_size
            
        }
    }
}

@end

@implementation UINavigationBar (MLNavigationBarTransition)

- (UIView*)_mlnbt_recursiveFindSubviewWithClassNames:(NSArray*)clsNames {
    UIView *curView = self;
    for (NSString *clsName in clsNames) {
        NSArray *subviews = [curView subviews];
        curView = nil;
        for (UIView *v in subviews) {
            if ([v isKindOfClass:NSClassFromString(clsName)]) {
                curView = v;
                break;
            }
        }
        if (!curView) {
            return nil;
        }
    }
    return curView;
}

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
    
    //    MLNBT_NSASSERT(NO, @"ml_backIndicatorView is not valid");
    //    return nil;
    
    //in iOS11, we only can find it with view hierarchy
//    NSLog(@"%@:%@",@"_UINavigationBarContentView",[@"_UINavigationBarContentView" mlnbt_EncryptString]);
//    NSLog(@"%@:%@",@"_UIButtonBarButton",[@"_UIButtonBarButton" mlnbt_EncryptString]);
//    NSLog(@"%@:%@",@"_UIModernBarButton",[@"_UIModernBarButton" mlnbt_EncryptString]);
    NSArray *clsNames = @[[@"K1IWGzS2nJquqTyioxWupxAioaEyoaEJnJI3" mlnbt_DecryptString],
                          [@"K1IWDaI0qT9hDzSlDaI0qT9h" mlnbt_DecryptString],
                          [@"K1IWGJ9xMKWhDzSlDaI0qT9h" mlnbt_DecryptString]];
    return [self _mlnbt_recursiveFindSubviewWithClassNames:clsNames];
}

- (UILabel*)ml_backButtonLabel {
    UILabel *label = nil;
    
    if ([UIDevice currentDevice].systemVersion.doubleValue>=11.0f) {
        //in iOS11, we only can find it with view hierarchy
//            NSLog(@"%@:%@",@"_UINavigationBarContentView",[@"_UINavigationBarContentView" mlnbt_EncryptString]);
//            NSLog(@"%@:%@",@"_UIButtonBarButton",[@"_UIButtonBarButton" mlnbt_EncryptString]);
//            NSLog(@"%@:%@",@"_UIBackButtonContainerView",[@"_UIBackButtonContainerView" mlnbt_EncryptString]);
//            NSLog(@"%@:%@",@"_UIModernBarButton",[@"_UIModernBarButton" mlnbt_EncryptString]);
//            NSLog(@"%@:%@",@"UIButtonLabel",[@"UIButtonLabel" mlnbt_EncryptString]);
        NSArray *clsNames = @[[@"K1IWGzS2nJquqTyioxWupxAioaEyoaEJnJI3" mlnbt_DecryptString],
                              [@"K1IWDaI0qT9hDzSlDaI0qT9h" mlnbt_DecryptString],
                              [@"K1IWDzSwn0W1qUEioxAioaEunJ5ypyMcMKp=" mlnbt_DecryptString],
                              [@"K1IWGJ9xMKWhDzSlDaI0qT9h" mlnbt_DecryptString],
                              [@"IHyPqKE0o25ZLJWyoN==" mlnbt_DecryptString],
                              ];
        return (UILabel*)[self _mlnbt_recursiveFindSubviewWithClassNames:clsNames];
    }
    
    @try {
        //    NSLog(@"%@:%@",@"_backButtonView",[@"_backButtonView" mlnbt_EncryptString]);
//            NSLog(@"%@:%@",@"_label",[@"_label" mlnbt_EncryptString]);
        UIView *backButtonView = [self.backItem valueForKey:[@"K2WuL2gPqKE0o25JnJI3" mlnbt_DecryptString]];
        label = [backButtonView valueForKey:[@"K2kuLzIf" mlnbt_DecryptString]];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
        MLNBT_NSASSERT(NO, @"ml_backButtonLabel is not valid");
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
    static NSString *varKey = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //  NSLog(@"%@:%@",@"_barBackgroundView",[@"_barBackgroundView" mlnbt_EncryptString]);
        //  NSLog(@"%@:%@",@"_backgroundView",[@"_backgroundView" mlnbt_EncryptString]);
        NSArray *keys = @[[@"K2WupxWuL2gapz91ozEJnJI3" mlnbt_DecryptString],[@"K2WuL2gapz91ozEJnJI3" mlnbt_DecryptString]];
        for (NSString *key in keys) {
            if (mlnbt_doesIvarExistWithName([self class], key)) {
                varKey = key;
                break;
            }
        }
        
        if (!varKey) {
            //in iOS11, it is a property named `_backgroundView`
            keys = @[[@"K2WuL2gapz91ozEJnJI3" mlnbt_DecryptString]];
            for (NSString *key in keys) {
                if (mlnbt_doesPropertyExistWithName([self class], key)) {
                    varKey = key;
                    break;
                }
            }
        }
    });
    if (varKey) {
        return [self valueForKey:varKey];
    }
    
    MLNBT_NSASSERT(NO, @"ml_backgroundView is not valid");
    return nil;
}

- (UIImage*)ml_currentBackgroundImage {
    static NSString *varKey = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //    NSLog(@"%@:%@",@"_backgroundImage",[@"_backgroundImage" mlnbt_EncryptString]);
        NSArray *keys = @[[@"K2WuL2gapz91ozEWoJSaMD==" mlnbt_DecryptString]];
        for (NSString *key in keys) {
            if (mlnbt_doesIvarExistWithName([self.ml_backgroundView class], key)) {
                varKey = key;
                break;
            }
        }
        if (!varKey) {
            //            NSLog(@"%@:%@",@"_currentCustomBackground",[@"_currentCustomBackground" mlnbt_EncryptString]);
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wundeclared-selector"
            NSString *selName = [@"K2A1paWyoaEQqKA0o21PLJAeM3WiqJ5x" mlnbt_DecryptString];
            if (self.ml_backgroundView&&class_getInstanceMethod([self.ml_backgroundView class],NSSelectorFromString(selName))) {
                varKey = selName;
            }
//            if ([self.ml_backgroundView respondsToSelector:NSSelectorFromString(selName)]) {
//                varKey = selName;
//            }
//#pragma clang diagnostic pop
        }
    });
    if (varKey) {
        return [self.ml_backgroundView valueForKey:varKey];
    }
    
    MLNBT_NSASSERT(NO, @"ml_currentBackgroundImage is not valid");
    return nil;
}

- (CGFloat)ml_backgroundAlpha {
    CGFloat alpha = self.ml_backgroundView.alpha;
    //    NSLog(@"%@:%@",@"_backgroundOpacity",[@"_backgroundOpacity" mlnbt_EncryptString]);
    SEL sel = NSSelectorFromString([@"K2WuL2gapz91ozECpTSwnKE5" mlnbt_DecryptString]);
    if (class_getInstanceMethod([UINavigationBar class], sel)) {
        @try {
            alpha = [[self mlnbt_performSelectorWithArgs:sel]doubleValue];
        } @catch  (NSException *exception) {
            alpha = self.ml_backgroundView.alpha;
            NSLog(@"backgroundOpacity of UINavigationBar is not exist now!");
        }
    }
    return alpha;
}

- (void)setMl_backgroundAlpha:(CGFloat)ml_backgroundAlpha {
    self.ml_backgroundView.alpha = ml_backgroundAlpha;
    //    NSLog(@"%@:%@",@"_setBackgroundOpacity:",[@"_setBackgroundOpacity:" mlnbt_EncryptString]);
    SEL sel = NSSelectorFromString([@"K3AyqRWuL2gapz91ozECpTSwnKE5Bt==" mlnbt_DecryptString]);
    if (class_getInstanceMethod([UINavigationBar class], sel)) {
        @try {
            [self mlnbt_performSelectorWithArgs:sel,ml_backgroundAlpha];
        } @catch (NSException *exception) {
            NSLog(@"setBackgroundOpacity: of UINavigationBar is not exist now!");
        }
    }
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
    bar.ml_backgroundAlpha = self.ml_backgroundAlpha;
    
    //shadow image view alpha and hidden
    bar.ml_backgroundShadowView.alpha = self.ml_backgroundShadowView.alpha;
    bar.ml_backgroundShadowView.hidden = self.ml_backgroundShadowView.hidden;
    
    //_barPosition is important
    @try {
        //    NSLog(@"%@:%@",@"_barPosition",[@"_barPosition" mlnbt_EncryptString]);
        [bar setValue:@(self.barPosition) forKey:[@"K2WupyOip2y0nJ9h" mlnbt_DecryptString]];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
        MLNBT_NSASSERT(NO, @"setting $barPosition is not valid");
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
        self.ml_backgroundAlpha != navigationBar.ml_backgroundAlpha||
        self.ml_backgroundShadowView.alpha != navigationBar.ml_backgroundShadowView.alpha||
        self.ml_backgroundShadowView.hidden != navigationBar.ml_backgroundShadowView.hidden
        ) {
        return NO;
    }
    
    if (!((!self.shadowImage&&!navigationBar.shadowImage)||[self.shadowImage isEqual:navigationBar.shadowImage]||[UIImagePNGRepresentation(self.shadowImage) isEqual:UIImagePNGRepresentation(navigationBar.shadowImage)])) {
        return NO;
    }
    
//    //if backgroundImages equal, ignore barTintColor
//    UIImage *backgroundImage1 = self.ml_currentBackgroundImage;
//    UIImage *backgroundImage2 = navigationBar.ml_currentBackgroundImage;
//    if ([backgroundImage1 isEqual:backgroundImage2]||[UIImagePNGRepresentation(backgroundImage1) isEqual:UIImagePNGRepresentation(backgroundImage2)]) {
//        return YES;
//    }
//
//    //if no backgroundImages, barTintColor should be cared
//    if (!backgroundImage1&&!backgroundImage2) {
//        if ((!self.barTintColor&&!navigationBar.barTintColor)||CGColorEqualToColor(self.barTintColor.CGColor, navigationBar.barTintColor.CGColor)) {
//            return YES;
//        }
//    }

    //sometimes(like iOS11) the the ml_currentBackgroundImage is not valid to compare now, so we use another way!
    __block BOOL allBackgroundImageNil = YES;
    BOOL (^imageEqualBlock)(UIImage *,UIImage *) = ^BOOL (UIImage *a,UIImage *b){
        if (!a&&!b) {
            return YES;
        }
        allBackgroundImageNil = NO;
        
        if ([a isEqual:b]) {
            return YES;
        }
        if ([UIImagePNGRepresentation(a) isEqual:UIImagePNGRepresentation(b)]) {
            return YES;
        }
        return NO;
    };

    if (imageEqualBlock([self backgroundImageForBarMetrics:UIBarMetricsDefault],[navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault])&&
        imageEqualBlock([self backgroundImageForBarMetrics:UIBarMetricsCompact],[navigationBar backgroundImageForBarMetrics:UIBarMetricsCompact])&&
        imageEqualBlock([self backgroundImageForBarMetrics:UIBarMetricsDefaultPrompt],[navigationBar backgroundImageForBarMetrics:UIBarMetricsDefaultPrompt])&&
        imageEqualBlock([self backgroundImageForBarMetrics:UIBarMetricsCompactPrompt],[navigationBar backgroundImageForBarMetrics:UIBarMetricsCompactPrompt])) {
        if (allBackgroundImageNil) {
            //if all nil ,care about barTintColor
            if ((!self.barTintColor&&!navigationBar.barTintColor)||CGColorEqualToColor(self.barTintColor.CGColor, navigationBar.barTintColor.CGColor)) {
                return YES;
            }
        }else{
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
    if (self.ml_backgroundView&&self.ml_backgroundAlpha==0.0f) {
        if ([r isEqual:self]||[r isEqual:self.ml_backgroundView]) {
            //Because although touching back button area, the r is always the bar. so we need do extra checking.
            @try {
                
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                //                    NSLog(@"%@->%@",@"_hasBackButton",[@"_hasBackButton" mlnbt_EncryptString]);
                //                    NSLog(@"%@->%@",@"_shouldPopForTouchAtPoint:",[@"_shouldPopForTouchAtPoint:" mlnbt_EncryptString]);
                BOOL hasBackButton = [[self mlnbt_performSelectorWithArgs:NSSelectorFromString([@"K2uup0WuL2gPqKE0o24=" mlnbt_DecryptString])]boolValue];
                BOOL shouldPopForTouchAtPoint = [[self mlnbt_performSelectorWithArgs:NSSelectorFromString([@"K3Abo3IfMSOipRMipyEiqJAbDKEDo2yhqQb=" mlnbt_DecryptString]),point]boolValue];
#pragma clang diagnostic pop
                if (hasBackButton&&shouldPopForTouchAtPoint) {
                    return r;
                }
            } @catch (NSException *exception) {
                NSLog(@"hasBackButton or shouldPopForTouchAtPoint of UINavigationBar is not exist now!");
                return nil;
            }
            
            return nil;
        }
    }
    return r;
}

@end
