#import <Foundation/Foundation.h>

typedef NSInteger (^IntegerBlock)();

NSInteger A (NSInteger kParam, IntegerBlock x1, IntegerBlock x2, IntegerBlock x3, IntegerBlock x4, IntegerBlock x5) {
    __block NSInteger k = kParam;
    __block IntegerBlock B; // due to a GCC bug, we have to initialize on a separate line
    B = ^ {
        return A(--k, B, x1, x2, x3, x4);
    };
    return k <= 0 ? x4() + x5() : B();
}

IntegerBlock K (NSInteger n) {
    IntegerBlock result = ^{return n;};
    return [[result copy] autorelease];
}

int main (int argc, const char * argv[]) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSInteger result = A(10, K(1), K(-1), K(-1), K(1), K(0));
    NSLog(@"%d\n", result);
    [pool drain];
    return 0;
}
