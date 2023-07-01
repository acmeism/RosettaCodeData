NSDictionary *myDict = [NSDictionary dictionaryWithObjectsAndKeys:
                        [NSNumber numberWithInt:13], @"hello",
                        [NSNumber numberWithInt:31], @"world",
                        [NSNumber numberWithInt:71], @"!", nil];

// iterating over keys:
for (id key in myDict) {
    NSLog(@"key = %@", key);
}

// iterating over values:
for (id value in [myDict objectEnumerator]) {
    NSLog(@"value = %@", value);
}
