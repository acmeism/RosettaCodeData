BOOL isNumericI(NSString *s)
{
   NSUInteger len = [s length];
   NSUInteger i;
   BOOL status = NO;

   for(i=0; i < len; i++)
   {
       unichar singlechar = [s characterAtIndex: i];
       if ( (singlechar == ' ') && (!status) )
       {
         continue;
       }
       if ( ( singlechar == '+' ||
              singlechar == '-' ) && (!status) ) { status=YES; continue; }
       if ( ( singlechar >= '0' ) &&
            ( singlechar <= '9' ) )
       {
          status = YES;
       } else {
          return NO;
       }
   }
   return (i == len) && status;
}
