#import <Foundation/Foundation.h>

int main()
{
   NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
   NSUInteger i;

   for(i=2008; i<2121; i++)
   {
      NSCalendarDate *d = [[NSCalendarDate alloc]
                           initWithYear: i
                           month: 12
                           day: 25
                           hour: 0 minute: 0 second:0
                           timeZone: [NSTimeZone timeZoneWithAbbreviation:@"CET"] ];
      if ( [d dayOfWeek] == 0 )
      {
         printf("25 Dec %u is Sunday\n", i);
      }
      [d release];
   }

   [pool release];
   return 0;
}
