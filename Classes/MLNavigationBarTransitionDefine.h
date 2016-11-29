//
//  MLNavigationBarTransitionDefine.h
//  MLNavigationBarTransition
//
//  Created by molon on 2016/11/30.
//  Copyright © 2016年 molon. All rights reserved.
//

#pragma once

#import <objc/runtime.h>

static inline BOOL mlnbt_doesIvarExistWithName(Class cls,NSString *ivarName) {
    unsigned int ivarCount = 0;
    Ivar *ivars = class_copyIvarList(cls, &ivarCount);
    if (ivars) {
        for (unsigned int i = 0; i < ivarCount; i++) {
            const char *name = ivar_getName(ivars[i]);
            if (name) {
                if ([[NSString stringWithUTF8String:name] isEqualToString:ivarName]) {
                    free(ivars);
                    return YES;
                }
            }
        }
        free(ivars);
    }
    return NO;
}

static inline BOOL mlnbt_exchangeInstanceMethod(Class cls, SEL originalSel, SEL newSel) {
    Method originalMethod = class_getInstanceMethod(cls, originalSel);
    Method newMethod = class_getInstanceMethod(cls, newSel);
    if (!originalMethod || !newMethod) return NO;
    
    method_exchangeImplementations(originalMethod,
                                   newMethod);
    return YES;
}
