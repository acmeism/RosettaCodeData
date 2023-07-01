NSLog(@"%@", [NSDate date]);
NSLog(@"%@", [[NSDate date] descriptionWithCalendarFormat:@"%Y-%m-%d" timeZone:nil locale:nil]);
NSLog(@"%@", [[NSDate date] descriptionWithCalendarFormat:@"%A, %B %d, %Y" timeZone:nil locale:nil]);
