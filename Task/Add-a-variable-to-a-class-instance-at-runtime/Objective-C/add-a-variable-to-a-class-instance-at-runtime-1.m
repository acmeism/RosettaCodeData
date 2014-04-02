#import <Foundation/Foundation.h>
#import <objc/runtime.h>

static char fooKey;

int main (int argc, const char *argv[]) {
    @autoreleasepool {

        id e = [[NSObject alloc] init];

        // set
        objc_setAssociatedObject(e, &fooKey, @1, OBJC_ASSOCIATION_RETAIN);

        // get
        NSNumber *associatedObject = objc_getAssociatedObject(e, &fooKey);
        NSLog(@"associatedObject: %@", associatedObject);

    }
    return 0;
}
