#import <Foundation/Foundation.h>

@interface GuessNumberFakeArray : NSArray
@end

@implementation GuessNumberFakeArray
- (NSUInteger)count { return NSUIntegerMax; }
- (id)objectAtIndex:(NSUInteger)i {
  printf("My guess is: %lu. Is it too high, too low, or correct? (H/L/C) ", i);
  char input[2] = "  ";
  scanf("%1s", input);
  switch (tolower(input[0])) {
    case 'l':
      return [NSNumber numberWithInt:-1];
    case 'h':
      return [NSNumber numberWithInt:1];
    case 'c':
      return [NSNumber numberWithInt:0];
  }
  return nil;
}
@end

#define LOWER 0
#define UPPER 100

int main(int argc, const char *argv[]) {
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

  printf("Instructions:\n"
         "Think of integer number from %d (inclusive) to %d (exclusive) and\n"
         "I will guess it. After each guess, you respond with L, H, or C depending\n"
         "on if my guess was too low, too high, or correct.\n",
         LOWER, UPPER);
  GuessNumberFakeArray *fakeArray = [GuessNumberFakeArray new];
  NSUInteger result = [fakeArray indexOfObject:[NSNumber numberWithInt: 0]
                                 inSortedRange:NSMakeRange(LOWER, UPPER)
                                       options:0
                               usingComparator:^(id x, id y){ return [x compare: y]; }];
  [fakeArray release];
  NSLog(@"Your number is %lu.", result);

  [pool release];
  return 0;
}
