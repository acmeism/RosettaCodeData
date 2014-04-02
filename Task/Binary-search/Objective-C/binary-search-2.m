#import <Foundation/Foundation.h>

@interface NSArray (BinarySearchRecursive)
// Requires all elements of this array to implement a -compare: method which
// returns a NSComparisonResult for comparison.
// Returns NSNotFound when not found
- (NSInteger) binarySearch:(id)key inRange:(NSRange)range;
@end

@implementation NSArray (BinarySearchRecursive)
- (NSInteger) binarySearch:(id)key inRange:(NSRange)range {
  if (range.length == 0)
    return NSNotFound;
  NSInteger mid = range.location + range.length / 2;
  id midVal = self[mid];
  switch ([midVal compare:key]) {
  case NSOrderedAscending:
    return [self binarySearch:key
                      inRange:NSMakeRange(mid + 1, NSMaxRange(range) - (mid + 1))];
  case NSOrderedDescending:
    return [self binarySearch:key
                      inRange:NSMakeRange(range.location, mid - range.location)];
  default:
    return mid;
  }
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
