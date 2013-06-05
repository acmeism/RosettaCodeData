+ (SomeSingleton *) sharedInstance
{
   static SomeSingleton *sharedInstance = nil;
   @synchronized(self) {
      if (!sharedInstance) {
         sharedInstance = [[SomeSingleton alloc] init];
      }
   }
   return sharedInstance;
}
