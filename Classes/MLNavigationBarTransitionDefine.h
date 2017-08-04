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

static inline BOOL mlnbt_doesPropertyExistWithName(Class cls,NSString *propertyName) {
    if (!cls) {
        return NO;
    }
    
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList(cls, &propertyCount);
    if (properties) {
        for (unsigned int i = 0; i < propertyCount; i++) {
            const char *name = property_getName(properties[i]);
            if (name) {
                if ([[NSString stringWithUTF8String:name] isEqualToString:propertyName]) {
                    free(properties);
                    return YES;
                }
            }
        }
        free(properties);
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

#ifdef DEBUG
    #define MLNBT_NSASSERT(valid,format, ...)                   \
        do { \
            if (!(valid)) {\
                NSString *astips = [NSString stringWithFormat:(format), ## __VA_ARGS__];\
        NSLog(@"\n-------------\n%s:%d\n%@\nPlease contact molon. https://github.com/molon/MLNavigationBarTransition/issues\n-------------", __PRETTY_FUNCTION__, __LINE__, astips);\
                NSAssert(NO, @"\n-------------\n%@\nPlease be assured that this assert will not be executed in the release environment!\nPlease contact molon. https://github.com/molon/MLNavigationBarTransition/issues\n-------------", astips);\
            }\
        }while(0)
#else
    #define MLNBT_NSASSERT(valid,format, ...)                   \
        do { \
        if (!(valid)) {\
        NSString *astips = [NSString stringWithFormat:(format), ## __VA_ARGS__];\
        NSLog(@"\n-------------\n%s:%d\n%@\nPlease contact molon. https://github.com/molon/MLNavigationBarTransition/issues\n-------------", __PRETTY_FUNCTION__, __LINE__, astips);\
        }\
        }while(0)
#endif

#define MLNBT_SYNTH_DUMMY_CLASS(_name_) \
@interface MLNBT_SYNTH_DUMMY_CLASS ## _name_ : NSObject @end \
@implementation MLNBT_SYNTH_DUMMY_CLASS ## _name_ @end

#define MLNBT_SYNTH_DYNAMIC_PROPERTY_OBJECT(_getter_, _setter_, _association_, _type_) \
- (void)_setter_ (_type_)object { \
[self willChangeValueForKey:@#_getter_]; \
objc_setAssociatedObject(self, _cmd, object, OBJC_ASSOCIATION_ ## _association_); \
[self didChangeValueForKey:@#_getter_]; \
} \
- (_type_)_getter_ { \
return objc_getAssociatedObject(self, @selector(_setter_)); \
}

#define MLNBT_SYNTH_DYNAMIC_PROPERTY_CTYPE(_getter_, _setter_, _type_) \
- (void)_setter_ (_type_)object { \
[self willChangeValueForKey:@#_getter_]; \
NSValue *value = [NSValue value:&object withObjCType:@encode(_type_)]; \
objc_setAssociatedObject(self, _cmd, value, OBJC_ASSOCIATION_RETAIN); \
[self didChangeValueForKey:@#_getter_]; \
} \
- (_type_)_getter_ { \
_type_ cValue = { 0 }; \
NSValue *value = objc_getAssociatedObject(self, @selector(_setter_)); \
[value getValue:&cValue]; \
return cValue; \
}
