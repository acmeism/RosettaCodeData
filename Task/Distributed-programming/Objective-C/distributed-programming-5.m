#import <Foundation/Foundation.h>
#import "ActionObjectProtocol.h"

int main(void)
{
  NSAutoreleasePool *pool;
  NSArray *args;
  id <ActionObjectProtocol> action;
  NSString *msg, *backmsg;

  pool = [[NSAutoreleasePool alloc] init];

  action = (id <ActionObjectProtocol>)
    [NSConnection
      rootProxyForConnectionWithRegisteredName: @"DistributedAction"
      host: @"localhost"
      usingNameServer: [NSSocketPortNameServer sharedInstance] ];

  if (action == nil)
  {
    NSLog(@"can't connect to the server");
    exit(EXIT_FAILURE);
  }

  args = [[NSProcessInfo processInfo] arguments];

  if ([args count] == 1)
  {
    NSLog(@"specify a message");
    exit(EXIT_FAILURE);
  }

  msg = [args objectAtIndex: 1];

  // "send" (call the selector "sendMessage:" of the (remote) object
  // action) the first argument's text as msg, store the message "sent
  // back" and then show it in the log
  backmsg = [action sendMessage: msg];
  NSLog("%@", backmsg);

  [pool release];
  return 0;
}
