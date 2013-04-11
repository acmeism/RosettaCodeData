int main()
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  NSArray *collection = [NSArray arrayWithObjects:
				 [NSNumber numberWithInt: 1],
				 [NSNumber numberWithInt: 2],
				 [NSNumber numberWithInt: 10],
				 [NSNumber numberWithInt: 5],
				 [NSNumber numberWithDouble: 10.5], nil];

  NSLog(@"%@", [collection maximumValue]);
  [pool release];
  return 0;
}
