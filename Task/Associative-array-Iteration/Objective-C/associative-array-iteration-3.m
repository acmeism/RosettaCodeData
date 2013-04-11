NSDictionary *myDict = [NSDictionary dictionaryWithObjectsAndKeys:
                        [NSNumber numberWithInt:13], @"hello",
                        [NSNumber numberWithInt:31], @"world",
                        [NSNumber numberWithInt:71], @"!", nil];

// iterating over keys and values:
[myDict enumerateKeysAndObjectsUsingBlock: ^(id key, id value, BOOL *stop) {
    NSLog(@"key = %@, value = %@", key, value);
}];
