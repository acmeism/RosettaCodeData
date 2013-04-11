#import <Foundation/Foundation.h>
#import <objc/runtime.h>

char fooKey;

int main (int argc, const char *argv[]) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    id e = [[NSObject alloc] init];

    // set
    objc_setAssociatedObject(e, &fooKey, [NSNumber numberWithInt:1], OBJC_ASSOCIATION_RETAIN);

    // get
    NSNumber *associatedObject = objc_getAssociatedObject(e, &fooKey);
    NSLog(@"associatedObject: %@", associatedObject);

    [e release];
    [pool drain];
    return 0;
}
