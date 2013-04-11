NSArray *haystack = [NSArray arrayWithObjects:@"Zig",@"Zag",@"Wally",@"Ronald",@"Bush",@"Krusty",@"Charlie",@"Bush",@"Bozo",nil];
for (id needle in [NSArray arrayWithObjects:@"Washington",@"Bush",nil]) {
    int index = [haystack indexOfObject:needle];
    if (index == NSNotFound)
        NSLog(@"%@ is not in haystack", needle);
    else
        NSLog(@"%i %@", index, needle);
}
