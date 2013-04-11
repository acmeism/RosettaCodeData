#import <Foundation/Foundation.h>

int main()
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  NSTimeInterval sleeptime;

  printf("wait time in seconds: ");
  scanf("%f", &sleeptime);

  NSLog(@"sleeping...");
  [NSThread sleepForTimeInterval: sleeptime];
  NSLog(@"awakening...");

  [pool release];
  return 0;
}
