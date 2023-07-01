NSString *myString = @"The quick brown fox jumped over the lazy dog's back";
NSData *digest = [[myString dataUsingEncoding:NSUTF8StringEncoding] md5Digest]; // or another encoding of your choosing
NSLog(@"%@", [digest hexadecimalRepresentation]);
