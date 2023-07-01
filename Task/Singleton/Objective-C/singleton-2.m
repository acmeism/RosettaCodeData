// SomeSingleton.m
@implementation SomeSingleton

+ (SomeSingleton *) sharedInstance
{
   static SomeSingleton *sharedInstance = nil;
   if (!sharedInstance) {
      sharedInstance = [[SomeSingleton alloc] init];
   }
   return sharedInstance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (unsigned)retainCount
{
    return UINT_MAX;
}

- (oneway void)release
{
    // prevent release
}

- (id)autorelease
{
    return self;
}

@end
