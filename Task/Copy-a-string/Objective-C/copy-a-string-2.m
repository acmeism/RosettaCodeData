NSMutableString *original = [NSMutableString stringWithString:@"Literal String"];
NSString *immutable = [original copy];
NSString *anotherImmutable = [NSString stringWithString:original];
NSMutableString *mutable = [original mutableCopy];
