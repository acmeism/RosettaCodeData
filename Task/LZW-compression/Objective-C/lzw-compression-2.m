const char *text = "TOBEORNOTTOBEORTOBEORNOT";

int main()
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

  NSMutableArray *array = [[NSMutableArray alloc] init];
  LZWCompressor *lzw = [[LZWCompressor alloc]
                        initWithArray: array ];
  if ( lzw )
  {
     [lzw compressData: [NSData dataWithBytes: text
                         length: strlen(text)]];
     NSEnumerator *en = [array objectEnumerator];
     id obj;
     while( (obj = [en nextObject]) )
     {
        printf("%u\n", [obj unsignedIntValue]);
     }
     [lzw release];
  }
  [array release];

  [pool release];
  return EXIT_SUCCESS;
}
