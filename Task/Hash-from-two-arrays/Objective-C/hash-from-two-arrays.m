NSArray *keys = [NSArray arrayWithObjects:@"a", @"b", @"c", nil];
NSArray *values = [NSArray arrayWithObjects:[NSNumber numberWithInt:1],
                                            [NSNumber numberWithInt:2],
                                            [NSNumber numberWithInt:3], nil];
NSDictionary *dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
