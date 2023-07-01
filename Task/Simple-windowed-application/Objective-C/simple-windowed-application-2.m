@implementation ClickMe : NSWindow
-(instancetype) init
{
  NSButton *button = [[NSButton alloc] init];
  [button setButtonType: NSToggleButton];
  [button setTitle: @"Click Me"];
  [button sizeToFit];
  [button setTarget: self];
  [button setAction: @selector(advanceCounter:)];
  NSRect buttonRect = [button frame];

  NSTextField *text = [[NSTextField alloc]
	   initWithFrame: NSMakeRect(buttonRect.origin.x, buttonRect.size.height,
				     buttonRect.size.width, buttonRect.size.height)];
  [text setAlignment: NSCenterTextAlignment];
  [text setEditable: NO];
  [text setStringValue: @"There have been no clicks yet"];
  [text sizeToFit];

  // reset size of button according to size of (larger...?) text
  [button
    setFrameSize: NSMakeSize( [text frame].size.width, buttonRect.size.height ) ];

  int totalWindowHeight = buttonRect.size.height + [text frame].size.height;

  if ((self = [super initWithContentRect: NSMakeRect(100, 100,
				    [text frame].size.width, totalWindowHeight)
        styleMask: (NSTitledWindowMask | NSClosableWindowMask)
      backing: NSBackingStoreBuffered
      defer: NO])) {
    _counter = 0;
    _button = button;
    _text = text;

    [[self contentView] addSubview: _text];
    [[self contentView] addSubview: _button];

    [self setTitle: @"Click Me!"];
    [self center];
  }
  return self;
}


- (void)applicationDidFinishLaunching: (NSNotification *)notification
{
  [self orderFront: self];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed: (NSNotification *)notification
{
  return YES;
}

- (void)advanceCounter: (id)sender
{
  [_text setStringValue: [NSString stringWithFormat: @"Clicked %d times", ++_counter]];
}
@end


int main()
{
  @autoreleasepool {
    NSApplication *app =  [NSApplication sharedApplication];
    ClickMe *clickme = [[ClickMe alloc] init];
    [app setDelegate: clickme];
    [app run];
  }
  return 0;
}
