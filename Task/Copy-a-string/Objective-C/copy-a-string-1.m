NSString *original = @"Literal String";
NSString *new = [original copy];
NSString *anotherNew = [NSString stringWithString:original];
NSString *newMutable = [original mutableCopy];
