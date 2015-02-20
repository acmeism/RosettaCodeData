#import <Foundation/Foundation.h>

@interface Node : NSObject {
@public
  id val;
  Node *back;
}
@end

@implementation Node
@end

@interface NSArray (LIS)
- (NSArray *)longestIncreasingSubsequenceWithComparator:(NSComparator)comparator;
@end

@implementation NSArray (LIS)
- (NSArray *)longestIncreasingSubsequenceWithComparator:(NSComparator)comparator {
  NSMutableArray *pileTops = [[NSMutableArray alloc] init];
  // sort into piles
  for (id x in self) {
    Node *node = [[Node alloc] init];
    node->val = x;
    int i = [pileTops indexOfObject:node
                      inSortedRange:NSMakeRange(0, [pileTops count])
                            options:NSBinarySearchingInsertionIndex|NSBinarySearchingFirstEqual
                    usingComparator:^NSComparisonResult(Node *node1, Node *node2) {
                      return comparator(node1->val, node2->val);
                    }];
    if (i != 0)
      node->back = pileTops[i-1];
    pileTops[i] = node;
  }

  // follow pointers from last node
  NSMutableArray *result = [[NSMutableArray alloc] init];
  for (Node *node = [pileTops lastObject]; node; node = node->back)
    [result addObject:node->val];
  return [[result reverseObjectEnumerator] allObjects];
}
@end

int main(int argc, const char *argv[]) {
  @autoreleasepool {
    for (NSArray *d in @[@[@3, @2, @6, @4, @5, @1],
         @[@0, @8, @4, @12, @2, @10, @6, @14, @1, @9, @5, @13, @3, @11, @7, @15]])
      NSLog(@"an L.I.S. of %@ is %@", d,
            [d longestIncreasingSubsequenceWithComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
      }]);
  }
  return 0;
}
