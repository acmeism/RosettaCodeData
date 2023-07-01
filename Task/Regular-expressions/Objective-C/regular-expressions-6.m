NSString *orig = @"I am the original string";
NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"original"
                                                                       options:0
                                                                         error:NULL];
NSString *result = [regex stringByReplacingMatchesInString:orig
                                                   options:0
                                                     range:NSMakeRange(0, [orig length])
                                              withTemplate:@"modified"];
NSLog(@"%@", result);
