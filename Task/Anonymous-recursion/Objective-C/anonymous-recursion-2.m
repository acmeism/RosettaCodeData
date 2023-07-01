#import <Foundation/Foundation.h>

int fib(int n) {
    if (n < 0)
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                 reason:@"fib: no negative numbers"
                               userInfo:nil];
    int (^f)(int);
    __block __weak int (^weak_f)(int); // block cannot capture strong reference to itself
    weak_f = f = ^(int n) {
        if (n < 2)
            return 1;
        else
            return weak_f(n-1) + weak_f(n-2);
    };
    return f(n);
}

int main (int argc, const char *argv[]) {
  @autoreleasepool {

    NSLog(@"%d", fib(8));

  }
  return 0;
}
