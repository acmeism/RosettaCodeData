#import <Foundation/Foundation.h>

// Formal protocol for the delegate
@protocol DelegatorDelegatingProtocol
    - (NSString *)thing;
@end

@interface Delegator : NSObject
    @property (weak) id delegate;
    - (NSString *)operation;
@end
@implementation Delegator
    - (NSString *)operation {
        if ([self.delegate respondsToSelector: @selector(thing)])
            return [self.delegate thing];

        return @"default implementation";
    }
@end

@interface Delegate : NSObject
    <DelegatorDelegatingProtocol>
@end
@implementation Delegate
    - (NSString *)thing { return @"delegate implementation"; }
@end

// Example usage with Automatic Reference Counting
int main() {
    @autoreleasepool {
        // Without a delegate:
        Delegator *a = [Delegator new];
        NSLog(@"%@", [a operation]);    // prints "default implementation"

        // With a delegate that does not implement thing:
        a.delegate = @"A delegate may be any object";
        NSLog(@"%@", [a operation]);    // prints "default implementation"

        // With a delegate that implements "thing":
        Delegate *d = [Delegate new];
        a.delegate = d;
        NSLog(@"%@", [a operation]);    // prints "delegate implementation"
    }
    return 0;
}
