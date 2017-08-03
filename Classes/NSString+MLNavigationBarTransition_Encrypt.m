//
//  NSString+MLNavigationBarTransition_Encrypt.m
//  Pods
//
//  Created by molon on 2017/1/6.
//
//

#import "NSString+MLNavigationBarTransition_Encrypt.h"
#import "MLNavigationBarTransitionDefine.h"

MLNBT_SYNTH_DUMMY_CLASS(NSString_MLNavigationBarTransition_Encrypt)

@implementation NSString (MLNavigationBarTransition_Encrypt)

- (NSString *)__mlnbt_Rot13 {
    const char *source = [self cStringUsingEncoding:NSASCIIStringEncoding];
    char *dest = (char *)malloc((self.length + 1) * sizeof(char));
    if (!dest) {
        return nil;
    }
    
    NSUInteger i = 0;
    for ( ; i < self.length; i++) {
        char c = source[i];
        if (c >= 'A' && c <= 'Z') {
            c = (c - 'A' + 13) % 26 + 'A';
        }
        else if (c >= 'a' && c <= 'z') {
            c = (c - 'a' + 13) % 26 + 'a';
        }
        dest[i] = c;
    }
    dest[i] = '\0';
    
    NSString *result = [[NSString alloc] initWithCString:dest encoding:NSASCIIStringEncoding];
    free(dest);
    
    return result;
}

- (NSString *)mlnbt_EncryptString {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64 = [data base64EncodedStringWithOptions:0];
    return [base64 __mlnbt_Rot13];
}

- (NSString *)mlnbt_DecryptString {
    NSString *rot13 = [self __mlnbt_Rot13];
    NSData *data = [[NSData alloc] initWithBase64EncodedString:rot13 options:0];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
