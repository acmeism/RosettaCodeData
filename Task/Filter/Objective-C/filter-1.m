NSArray *numbers = [NSArray arrayWithObjects:[NSNumber numberWithInt:1],
                                             [NSNumber numberWithInt:2],
                                             [NSNumber numberWithInt:3],
                                             [NSNumber numberWithInt:4],
                                             [NSNumber numberWithInt:5], nil];
NSArray *evens = [numbers objectsAtIndexes:[numbers indexesOfObjectsPassingTest:
  ^BOOL(id obj, NSUInteger idx, BOOL *stop) { return [obj intValue] % 2 == 0; } ]];
