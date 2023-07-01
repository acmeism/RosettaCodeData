+ (SomeSingleton *) sharedInstance
{
   static SomeSingleton *sharedInstance = nil;
   static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{
      sharedInstance = [[SomeSingleton alloc] init];
   });
   return sharedInstance;
}
