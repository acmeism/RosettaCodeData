NSArray *haystack = [NSArray arrayWithObjects:@"Zig",@"Zag",@"Wally",@"Ronald",@"Bush",@"Krusty",@"Charlie",@"Bush",@"Bozo",nil];
id needle;
NSEnumerator *enm = [[NSArray arrayWithObjects:@"Washington",@"Bush",nil] objectEnumerator];
while ((needle = [enm nextObject]) != nil) {
    int index = [haystack indexOfObject:needle];
    if (index == NSNotFound)
        NSLog(@"%@ is not in haystack", needle);
    else
        NSLog(@"%i %@", index, needle);
}
