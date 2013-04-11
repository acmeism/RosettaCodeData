#import <Foundation/Foundation.h>

int main (int argc, const char *argv[]) {
  NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

  NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithUTF8String:argv[1]]];
  NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
  NSCountedSet *countedSet = [[NSCountedSet alloc] init];
  NSUInteger len = [string length];
  for (NSUInteger i = 0; i < len; i++) {
    unichar c = [string characterAtIndex:i];
    if ([[NSCharacterSet letterCharacterSet] characterIsMember:c])
      [countedSet addObject:[NSNumber numberWithInteger:c]];
  }
  [string release];
  for (NSNumber *chr in countedSet) {
    NSLog(@"%C => %lu", (unichar)[chr integerValue], [countedSet countForObject:chr]);
  }
  [countedSet release];

  [pool release];
  return 0;
}
