#import <Foundation/Foundation.h>

int main(int argc, const char *argv[]) {
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

  NSDate *t = [NSDate dateWithTimeIntervalSinceReferenceDate:0];
  NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
  [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
  [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZ"];
  NSLog(@"%@", [dateFormatter stringFromDate:t]);

  [pool release];
  return 0;
}
