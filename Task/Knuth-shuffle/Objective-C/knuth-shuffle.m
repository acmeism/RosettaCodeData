#import <Foundation/Foundation.h>

@interface NSMutableArray (KnuthShuffle)
- (void)knuthShuffle;
@end
@implementation NSMutableArray (KnuthShuffle)
- (void)knuthShuffle {
  for (NSUInteger i = self.count-1; i > 0; i--) {
    NSUInteger j = arc4random_uniform(i+1);
    [self exchangeObjectAtIndex:i withObjectAtIndex:j];
  }
}
@end

int main() {
  @autoreleasepool {
    NSMutableArray *x = [NSMutableArray arrayWithObjects:@0, @1, @2, @3, @4, @5, @6, @7, @8, @9, nil];
    [x knuthShuffle];
    NSLog(@"%@", x);
  }
  return 0;
}
