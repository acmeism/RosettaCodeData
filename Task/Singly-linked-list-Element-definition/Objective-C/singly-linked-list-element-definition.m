#import <Foundation/Foundation.h>

@interface RCListElement<T> : NSObject
{
  RCListElement<T> *next;
  T datum;
}
- (RCListElement<T> *)next;
- (T)datum;
- (RCListElement<T> *)setNext: (RCListElement<T> *)nx;
- (void)setDatum: (T)d;
@end

@implementation RCListElement
- (RCListElement *)next
{
  return next;
}
- (id)datum
{
  return datum;
}
- (RCListElement *)setNext: (RCListElement *)nx
{
  RCListElement *p = next;
  next = nx;
  return p;
}
- (void)setDatum: (id)d
{
  datum = d;
}
@end
