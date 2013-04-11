NSString *str = @"I am a string";
if ([str rangeOfString:@"string$" options:NSRegularExpressionSearch].location != NSNotFound) {
    NSLog(@"Ends with 'string'");
}
