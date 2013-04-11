#import <Foundation/Foundation.h>

const void *PQRetain(CFAllocatorRef allocator, const void *ptr) {
  return [(id)ptr retain];
}
void PQRelease(CFAllocatorRef allocator, const void *ptr) {
  [(id)ptr release];
}
CFComparisonResult PQCompare(const void *ptr1, const void *ptr2, void *unused) {
  return [(id)ptr1 compare:(id)ptr2];
}

@interface Task : NSObject {
  int priority;
  NSString *name;
}
- (id)initWithPriority:(int)p andName:(NSString *)n;
- (NSComparisonResult)compare:(Task *)other;
@end

@implementation Task
- (id)initWithPriority:(int)p andName:(NSString *)n {
  if ((self = [super init])) {
    priority = p;
    name = [n copy];
  }
  return self;
}
- (void)dealloc {
  [name release];
  [super dealloc];
}
- (NSString *)description {
  return [NSString stringWithFormat:@"%d, %@", priority, name];
}
- (NSComparisonResult)compare:(Task *)other {
  if (priority == other->priority)
    return NSOrderedSame;
  else if (priority < other->priority)
    return NSOrderedAscending;
  else
    return NSOrderedDescending;
}
@end

int main (int argc, const char *argv[]) {
  NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

  CFBinaryHeapCallBacks callBacks = {0, PQRetain, PQRelease, NULL, PQCompare};
  CFBinaryHeapRef pq = CFBinaryHeapCreate(NULL, 0, &callBacks, NULL);

  CFBinaryHeapAddValue(pq, [[[Task alloc] initWithPriority:3 andName:@"Clear drains"] autorelease]);
  CFBinaryHeapAddValue(pq, [[[Task alloc] initWithPriority:4 andName:@"Feed cat"] autorelease]);
  CFBinaryHeapAddValue(pq, [[[Task alloc] initWithPriority:5 andName:@"Make tea"] autorelease]);
  CFBinaryHeapAddValue(pq, [[[Task alloc] initWithPriority:1 andName:@"Solve RC tasks"] autorelease]);
  CFBinaryHeapAddValue(pq, [[[Task alloc] initWithPriority:2 andName:@"Tax return"] autorelease]);

  while (CFBinaryHeapGetCount(pq) != 0) {
    Task *task = (id)CFBinaryHeapGetMinimum(pq);
    NSLog(@"%@", task);
    CFBinaryHeapRemoveMinimumValue(pq);
  }

  CFRelease(pq);

  [pool drain];
  return 0;
}
