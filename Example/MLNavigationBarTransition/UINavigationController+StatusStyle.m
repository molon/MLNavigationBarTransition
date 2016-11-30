//
//  UINavigationController+StatusStyle.m
//  MLNavigationBarTransition
//
//  Created by molon on 2016/11/30.
//  Copyright © 2016年 molon. All rights reserved.
//

#import "UINavigationController+StatusStyle.h"

@implementation UINavigationController (StatusStyle)

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self.topViewController preferredStatusBarStyle];
}

@end
