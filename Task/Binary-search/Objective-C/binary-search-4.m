#import <Foundation/Foundation.h>

CFComparisonResult myComparator(const void *x, const void *y, void *context) {
  return [(__bridge id)x compare:(__bridge id)y];
}

int main(int argc, const char *argv[]) {
  @autoreleasepool {

    NSArray *a = @[@1, @3, @4, @5, @6, @7, @8, @9, @10];
    NSLog(@"6 is at position %ld", CFArrayBSearchValues((__bridge CFArrayRef)a,
                                                        CFRangeMake(0, [a count]),
                                                        (__bridge const void *)@6,
                                                        myComparator,
                                                        NULL)); // prints 4

  }
  return 0;
}
