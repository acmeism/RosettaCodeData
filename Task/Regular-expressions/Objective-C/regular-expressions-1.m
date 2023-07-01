NSString *str = @"I am a string";
NSString *regex = @".*string$";

// Note: the MATCHES operator matches the entire string, necessitating the ".*"
NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];

if ([pred evaluateWithObject:str]) {
    NSLog(@"ends with 'string'");
}
