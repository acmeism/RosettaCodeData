NSString *normal = @"http://foo bar/";
NSString *encoded = [normal stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]];
NSLog(@"%@", encoded);
