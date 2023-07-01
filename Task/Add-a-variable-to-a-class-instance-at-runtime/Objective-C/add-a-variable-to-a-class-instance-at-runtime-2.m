#import <Foundation/Foundation.h>
#import <objc/runtime.h>

int main (int argc, const char *argv[]) {
    @autoreleasepool {

        id e = [[NSObject alloc] init];

        // set
        objc_setAssociatedObject(e, @selector(foo), @1, OBJC_ASSOCIATION_RETAIN);

        // get
        NSNumber *associatedObject = objc_getAssociatedObject(e, @selector(foo));
        NSLog(@"associatedObject: %@", associatedObject);

    }
    return 0;
}
