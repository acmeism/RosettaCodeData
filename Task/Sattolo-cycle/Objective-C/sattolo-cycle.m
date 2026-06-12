#import <Foundation/Foundation.h>

@interface NSMutableArray (SattoloCycle)
- (void)sattoloCycle;
@end
@implementation NSMutableArray (SattoloCycle)
- (void)sattoloCycle {
  for (NSUInteger i = self.count-1; i > 0; i--) {
    NSUInteger j = arc4random_uniform(i);
    [self exchangeObjectAtIndex:i withObjectAtIndex:j];
  }
}
@end
