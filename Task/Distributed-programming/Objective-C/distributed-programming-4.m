#import <Foundation/Foundation.h>
#import "ActionObject.h"

int main (void)
{
  @autoreleasepool {

    ActionObject *action = [[ActionObject alloc] init];

    NSSocketPort *port = (NSSocketPort *)[NSSocketPort port];
    // initWithTCPPort: 1234 and other methods are not supported yet
    // by GNUstep
    NSConnection *connect = [NSConnection
  	      connectionWithReceivePort: port
  	      sendPort: port]; // or sendPort: nil

    [connect setRootObject: action];

    /* "vend" the object ActionObject as DistributedAction; on GNUstep
       the Name Server that allows the resolution of the registered name
       is bound to port 538 */
    if (![connect registerName:@"DistributedAction"
  	       withNameServer: [NSSocketPortNameServer sharedInstance] ])
    {
      NSLog(@"can't register the server DistributedAction");
      exit(EXIT_FAILURE);
    }

    NSLog(@"waiting for messages...");

    [[NSRunLoop currentRunLoop] run];

  }
  return 0;
}
