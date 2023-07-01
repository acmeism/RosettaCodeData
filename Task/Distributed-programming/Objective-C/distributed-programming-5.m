#import <Foundation/Foundation.h>
#import "ActionObjectProtocol.h"

int main(void)
{
  @autoreleasepool {

    id <ActionObjectProtocol> action = (id <ActionObjectProtocol>)
      [NSConnection
        rootProxyForConnectionWithRegisteredName: @"DistributedAction"
        host: @"localhost"
        usingNameServer: [NSSocketPortNameServer sharedInstance] ];

    if (action == nil)
    {
      NSLog(@"can't connect to the server");
      exit(EXIT_FAILURE);
    }

    NSArray *args = [[NSProcessInfo processInfo] arguments];

    if ([args count] == 1)
    {
      NSLog(@"specify a message");
      exit(EXIT_FAILURE);
    }

    NSString *msg = args[1];

    // "send" (call the selector "sendMessage:" of the (remote) object
    // action) the first argument's text as msg, store the message "sent
    // back" and then show it in the log
    NSString *backmsg = [action sendMessage: msg];
    NSLog("%@", backmsg);

  }
  return 0;
}
