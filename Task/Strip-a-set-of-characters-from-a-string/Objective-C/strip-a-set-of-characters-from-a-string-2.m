    NSString *aString = @"She was a soul stripper. She took my heart!";
    NSCharacterSet* chars = [NSCharacterSet characterSetWithCharactersInString:@"aei"];

    // Display the NSString.
    NSLog(@"%@", [aString stripCharactersInSet:chars]);
