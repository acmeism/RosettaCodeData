NSArray *symbols = [NSThread callStackSymbols];
for (NSString *symbol in symbols) {
    NSLog(@"%@", symbol);
}
