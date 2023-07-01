BOOL isNumeric(NSString *s)
{
   NSScanner *sc = [NSScanner scannerWithString: s];
   if ( [sc scanFloat:NULL] )
   {
      return [sc isAtEnd];
   }
   return NO;
}
