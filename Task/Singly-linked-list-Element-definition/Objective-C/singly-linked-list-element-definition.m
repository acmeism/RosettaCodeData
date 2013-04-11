#import <objc/Object.h>

@interface RCListElement : Object
{
  RCListElement *next;
  id datum;
}
+ (RCListElement *)new;
- (RCListElement *)next;
- (id)datum;
- (RCListElement *)setNext: (RCListElement *)nx;
- (void)setDatum: (id)d;
@end

@implementation RCListElement
+ (RCListElement *)new
{
  RCListElement *m = [super new];
  [m setNext: nil];
  [m setDatum: nil];
  return m;
}
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
  RCListElement *p;
  p = next;
  next = nx;
  return p;
}
- (void)setDatum: (id)d
{
  datum = d;
}
@end
