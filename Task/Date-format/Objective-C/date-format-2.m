NSLog(@"%@", [NSDate date]);
NSDateFormatter *dateFormatter = [[NSDateFormat alloc] init];
[dateFormatter setDateFormat:@"yyyy-MM-dd"];
NSLog(@"%@", [dateFormatter stringFromDate:[NSDate date]]);
[dateFormatter setDateFormat:@"EEEE, MMMM d, yyyy"];
NSLog(@"%@", [dateFormatter stringFromDate:[NSDate date]]);
[dateFormatter release];
