#import <Foundation/Foundation.h>

@interface NSArray (Mode)
- (NSArray *)mode;
@end

@implementation NSArray (Mode)
- (NSArray *)mode {
    NSCountedSet *seen = [NSCountedSet setWithArray:self];
    int max = 0;
    NSMutableArray *maxElems = [NSMutableArray array];
    NSEnumerator *enm = [seen objectEnumerator];
    id obj;
    while( (obj = [enm nextObject]) ) {
        int count = [seen countForObject:obj];
        if (count > max) {
            max = count;
            [maxElems removeAllObjects];
            [maxElems addObject:obj];
        } else if (count == max) {
            [maxElems addObject:obj];
        }
    }
    return maxElems;
}
@end
