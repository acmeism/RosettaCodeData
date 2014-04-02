#import <Foundation/Foundation.h>

int main()
{
  @autoreleasepool {

    NSArray *a = @[@1, @3, @4, @5, @6, @7, @8, @9, @10];
    NSLog(@"6 is at position %lu", [a indexOfObject:@6
                                      inSortedRange:NSMakeRange(0, [a count])
                                            options:0
                                    usingComparator:^(id x, id y){ return [x compare: y]; }]); // prints 4

  }
  return 0;
}
