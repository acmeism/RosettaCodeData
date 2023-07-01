NSArray *numbers = [NSArray arrayWithObjects:[NSNumber numberWithInt:1],
                                             [NSNumber numberWithInt:2],
                                             [NSNumber numberWithInt:3],
                                             [NSNumber numberWithInt:4],
                                             [NSNumber numberWithInt:5], nil];
NSPredicate *isEven = [NSPredicate predicateWithFormat:@"modulus:by:(SELF, 2) == 0"];
NSArray *evens = [numbers filteredArrayUsingPredicate:isEven];
