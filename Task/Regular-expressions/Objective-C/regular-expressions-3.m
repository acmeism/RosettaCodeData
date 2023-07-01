NSString *orig = @"I am the original string";
NSString *result = [orig stringByReplacingOccurrencesOfString:@"original"
                                                   withString:@"modified"
                                                      options:NSRegularExpressionSearch
                                                        range:NSMakeRange(0, [orig length])];
NSLog(@"%@", result);
