#import <Foundation/Foundation.h>

@interface Delegator : NSObject {

    id delegate;
}

- (id)delegate;
- (void)setDelegate:(id)obj;
- (NSString *)operation;

@end

@implementation Delegator

- (id)delegate {

    return delegate;
}

- (void)setDelegate:(id)obj {

    delegate = obj; // Weak reference
}

- (NSString *)operation {

    if ([delegate respondsToSelector:@selector(thing)])
        return [delegate thing];

    return @"default implementation";
}

@end

// Any object may implement these
@interface NSObject (DelegatorDelegating)

- (NSString *)thing;

@end

@interface Delegate : NSObject

// Don't need to declare -thing because any NSObject has this method

@end

@implementation Delegate

- (NSString *)thing {

    return @"delegate implementation";
}

@end

// Example usage
// Memory management ignored for simplification
int main() {

    // Without a delegate:
    Delegator *a = [[Delegator alloc] init];
    NSLog(@"%d\n", [[a operation] isEqualToString:@"default implementation"]);

    // With a delegate that does not implement thing:
    [a setDelegate:@"A delegate may be any object"];
    NSLog(@"%d\n", [[a operation] isEqualToString:@"delegate implementation"]);

    // With a delegate that implements "thing":
    Delegate *d = [[Delegate alloc] init];
    [a setDelegate:d];
    NSLog(@"%d\n", [[a operation] isEqualToString:@"delegate implementation"]);

    return 0;
}
