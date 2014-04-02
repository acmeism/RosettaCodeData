NSString *text = @"TOBEORNOTTOBEORTOBEORNOT";

int main()
{
  @autoreleasepool {

    NSMutableArray *array = [[NSMutableArray alloc] init];
    LZWCompressor *lzw = [[LZWCompressor alloc]
                          initWithArray: array ];
    if ( lzw )
    {
       [lzw compressData: [text dataUsingEncoding: NSUTF8StringEncoding]];
       for ( id obj in array )
       {
          printf("%u\n", [obj unsignedIntValue]);
       }
    }

  }
  return EXIT_SUCCESS;
}
