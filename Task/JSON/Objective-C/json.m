NSString *json_string = @"{ \"foo\": 1, \"bar\": [10, \"apples\"] }";
id obj = [NSJSONSerialization JSONObjectWithData:[json_string dataUsingEncoding:NSUTF8StringEncoding]
                                         options:0
                                           error:NULL];
NSLog(@"%@", obj);

id obj2 = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObjects:[NSNumber numberWithInt:1],
                                                                               [NSNumber numberWithInt:2],
                                                                               nil],
                                                             @"blue",
                                                     @"water", @"ocean",
                                                     nil];
NSString *json_string2 = [[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:obj2
                                                                                         options:0
                                                                                           error:NULL]
                                                encoding:NSUTF8StringEncoding] autorelease];
NSLog(@"%@", json_string2);
