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
    if (!cls) {
        return NO;
    }
    
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
    if (!cls) {
        return NO;
    }
    
    Method originalMethod = class_getInstanceMethod(cls, originalSel);
    Method newMethod = class_getInstanceMethod(cls, newSel);
    if (!originalMethod || !newMethod) return NO;
    
    method_exchangeImplementations(originalMethod,
                                   newMethod);
    return YES;
}


#define MLNBT_SYNTH_DUMMY_CLASS(_name_) \
@interface SYNTH_DUMMY_CLASS_ ## _name_ : NSObject @end \
@implementation SYNTH_DUMMY_CLASS_ ## _name_ @end


#define MLNBT_SYNTH_DYNAMIC_PROPERTY_OBJECT(_getter_, _setter_, _association_, _type_) \
- (void)_setter_ (_type_)object { \
[self willChangeValueForKey:@#_getter_]; \
objc_setAssociatedObject(self, _cmd, object, OBJC_ASSOCIATION_ ## _association_); \
[self didChangeValueForKey:@#_getter_]; \
} \
- (_type_)_getter_ { \
return objc_getAssociatedObject(self, @selector(_setter_)); \
}
