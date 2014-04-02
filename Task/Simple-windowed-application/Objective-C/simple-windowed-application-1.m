#include <Foundation/Foundation.h>
#include <AppKit/AppKit.h>

@interface ClickMe : NSWindow
{
  NSButton *_button;
  NSTextField *_text;
  int _counter;
}
- (void)applicationDidFinishLaunching: (NSNotification *)notification;
- (BOOL)applicationShouldTerminateAfterLastWindowClosed: (NSNotification *)notification;
- (void)advanceCounter: (id)sender;
@end
