#import <Foundation/Foundation.h>

@interface NSArray (BinarySearch)
// Requires all elements of this array to implement a -compare: method which
// returns a NSComparisonResult for comparison.
// Returns NSNotFound when not found
- (NSInteger) binarySearch:(id)key;
@end

@implementation NSArray (BinarySearch)
- (NSInteger) binarySearch:(id)key {
  NSInteger lo = 0;
  NSInteger hi = [self count] - 1;
  while (lo <= hi) {
    NSInteger mid = lo + (hi - lo) / 2;
    id midVal = self[mid];
    switch ([midVal compare:key]) {
    case NSOrderedAscending:
      lo = mid + 1;
      break;
    case NSOrderedDescending:
      hi = mid - 1;
      break;
    case NSOrderedSame:
      return mid;
    }
  }
  return NSNotFound;
}
@end

int main()
{
  @autoreleasepool {

    NSArray *a = @[@1, @3, @4, @5, @6, @7, @8, @9, @10];
    NSLog(@"6 is at position %d", [a binarySearch:@6]); // prints 4

  }
  return 0;
}
