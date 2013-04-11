#import <Foundation/Foundation.h>

@interface DisjointSublistView : NSMutableArray {
  NSMutableArray *array;
  int *indexes;
  int num_indexes;
}
- (id)initWithArray:(NSMutableArray *)a andIndexes:(NSIndexSet *)ind;
@end

@implementation DisjointSublistView
- (id)initWithArray:(NSMutableArray *)a andIndexes:(NSIndexSet *)ind {
  if ((self = [super init])) {
    array = [a retain];
    num_indexes = [ind count];
    indexes = malloc(num_indexes * sizeof(int));
    for (NSUInteger i = [ind firstIndex], j = 0; i != NSNotFound; i = [ind indexGreaterThanIndex:i], j++)
      indexes[j] = i;
  }
  return self;
}
- (void)dealloc {
  [array release];
  free(indexes);
  [super dealloc];
}
- (NSUInteger)count { return num_indexes; }
- (id)objectAtIndex:(NSUInteger)i { return [array objectAtIndex:indexes[i]]; }
- (void)replaceObjectAtIndex:(NSUInteger)i withObject:(id)x {
  return [array replaceObjectAtIndex:indexes[i] withObject:x]; }
@end

@interface NSMutableArray (SortDisjoint)
- (void)sortDisjointSublist:(NSIndexSet *)indexes usingSelector:(SEL)comparator;
@end
@implementation NSMutableArray (SortDisjoint)
- (void)sortDisjointSublist:(NSIndexSet *)indexes usingSelector:(SEL)comparator {
  DisjointSublistView *d = [[DisjointSublistView alloc] initWithArray:self andIndexes:indexes];
  [d sortUsingSelector:comparator];
  [d release];
}
@end

int main(int argc, const char *argv[]) {
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

  NSMutableArray *a = [NSMutableArray arrayWithObjects:
                       [NSNumber numberWithInt:7],
                       [NSNumber numberWithInt:6],
                       [NSNumber numberWithInt:5],
                       [NSNumber numberWithInt:4],
                       [NSNumber numberWithInt:3],
                       [NSNumber numberWithInt:2],
                       [NSNumber numberWithInt:1],
                       [NSNumber numberWithInt:0],
                       nil];
  NSMutableIndexSet *ind = [NSMutableIndexSet indexSet];
  [ind addIndex:6]; [ind addIndex:1]; [ind addIndex:7];
  [a sortDisjointSublist:ind usingSelector:@selector(compare:)];
  NSLog(@"%@", a);

  [pool release];
  return 0;
}
