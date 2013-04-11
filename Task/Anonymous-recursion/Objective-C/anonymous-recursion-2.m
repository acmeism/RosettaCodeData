#import <Foundation/Foundation.h>

int fib(int n) {
    if (n < 0)
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                 reason:@"fib: no negative numbers"
                               userInfo:nil];
    __block int (^f)(int);
    f = ^(int n) {
        if (n < 2)
            return 1;
        else
            return f(n-1) + f(n-2);
    };
    return f(n);
}

int main (int argc, const char *argv[]) {
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

  NSLog(@"%d", fib(8));

  [pool release];
  return 0;
}
