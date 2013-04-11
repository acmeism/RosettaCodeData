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
    id midVal = [self objectAtIndex:mid];
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
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

  NSArray *a = [NSArray arrayWithObjects:
		   [NSNumber numberWithInt: 1],
		   [NSNumber numberWithInt: 3],
		   [NSNumber numberWithInt: 4],
		   [NSNumber numberWithInt: 5],
		   [NSNumber numberWithInt: 6],
		   [NSNumber numberWithInt: 7],
		   [NSNumber numberWithInt: 8],
		   [NSNumber numberWithInt: 9],
		   [NSNumber numberWithInt: 10],
		   nil];
  NSLog(@"6 is at position %d", [a binarySearch:[NSNumber numberWithInt: 6]]); // prints 4

  [pool drain];
  return 0;
}
