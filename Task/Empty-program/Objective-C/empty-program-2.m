#import <Cocoa/Cocoa.h>

int main( int argc, const char *argv[] )
{
  NSAutoreleasePool *pool;

  pool = [[NSAutoreleasePool alloc] init];
  NSApp = [NSApplication sharedApplication];

  [pool release];
  return 0;
}
