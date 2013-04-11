#import <Foundation/Foundation.h>

typedef double (^Accumulator)(double);

Accumulator accumulator_factory(double initial) {
    __block double sum = initial;
    Accumulator acc = ^(double n){
        return sum += n;
    };
    return [[acc copy] autorelease];
}

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

    Accumulator x = accumulator_factory(1);
    x(5);
    accumulator_factory(3);
    NSLog(@"%f", x(2.3));
	
    [pool drain];
    return 0;
}
