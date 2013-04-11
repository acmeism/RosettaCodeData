NSDictionary *myDict = [NSDictionary dictionaryWithObjectsAndKeys:
                        [NSNumber numberWithInt:13], @"hello",
                        [NSNumber numberWithInt:31], @"world",
                        [NSNumber numberWithInt:71], @"!", nil];

// iterating over keys:
NSEnumerator *enm = [myDict keyEnumerator];
id key;
while ((key = [enm nextObject])) {
    NSLog(@"key = %@", key);
}

// iterating over values:
enm = [myDict objectEnumerator];
id value;
while ((value = [enm nextObject])) {
    NSLog(@"value = %@", value);
}
