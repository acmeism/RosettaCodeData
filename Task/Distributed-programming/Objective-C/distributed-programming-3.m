#import <Foundation/Foundation.h>
#import "ActionObject.h"

@implementation ActionObject
-(NSString *)sendMessage: (NSString *)msg
{
  NSLog(@"client sending message %@", msg);
  return @"server answers ...";
}
@end
