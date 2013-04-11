#include <Foundation/Foundation.h>
#include <AppKit/AppKit.h>

@interface ClickMe : NSWindow
{
  NSButton *button;
  NSTextField *text;
  int counter;
}
- (void)applicationDidFinishLaunching: (NSNotification *)notification;
- (BOOL)applicationShouldTerminateAfterLastWindowClosed: (NSNotification *)notification;
- (void)advanceCounter: (id)sender;
@end
