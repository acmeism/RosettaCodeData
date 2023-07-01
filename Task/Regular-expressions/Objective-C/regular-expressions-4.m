NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"string$"
                                                                       options:0
                                                                         error:NULL];
NSString *str = @"I am a string";
if ([regex rangeOfFirstMatchInString:str
                             options:0
                               range:NSMakeRange(0, [str length])
     ].location != NSNotFound) {
    NSLog(@"Ends with 'string'");
}
