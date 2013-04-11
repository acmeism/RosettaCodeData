@implementation ClickMe : NSWindow
-(id) init
{
  NSRect buttonRect;
  int totalWindowHeight;

  counter = 0;
  button = [[NSButton alloc] init];
  [button setButtonType: NSToggleButton];
  [button setTitle: @"Click Me"];
  [button sizeToFit];
  [button setTarget: self];
  [button setAction: @selector(advanceCounter:)];
  buttonRect = [button frame];

  text = [[NSTextField alloc]
	   initWithFrame: NSMakeRect(buttonRect.origin.x, buttonRect.size.height,
				     buttonRect.size.width, buttonRect.size.height)];
  [text setAlignment: NSCenterTextAlignment];
  [text setEditable: NO];
  [text setStringValue: @"There have been no clicks yet"];
  [text sizeToFit];

  // reset size of button according to size of (larger...?) text
  [button
    setFrameSize: NSMakeSize( [text frame].size.width, buttonRect.size.height ) ];

  totalWindowHeight = buttonRect.size.height + [text frame].size.height;

  [self
    initWithContentRect: NSMakeRect(100, 100,
				    [text frame].size.width, totalWindowHeight)
    styleMask: (NSTitledWindowMask | NSClosableWindowMask)
    backing: NSBackingStoreBuffered
    defer: NO];

  [[self contentView] addSubview: text];   [text release];
  [[self contentView] addSubview: button]; [button release];

  [self setTitle: @"Click Me!"];
  [self center];

  return self;
}


-(void) dealloc
{
  [button release];
  [text release];
  [super dealloc];
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
  counter++;
  [text setStringValue: [NSString stringWithFormat: @"Clicked %d times", counter]];
}
@end


int main()
{
  ClickMe *clickme;
  NSAutoreleasePool *pool;
  NSApplication *app;

  pool = [[NSAutoreleasePool alloc] init];
  app =  [NSApplication sharedApplication];
  clickme = [[ClickMe alloc] init];
  [app setDelegate: clickme];
  [app run];
  [clickme release];
  [pool release];
  return 0;
}
