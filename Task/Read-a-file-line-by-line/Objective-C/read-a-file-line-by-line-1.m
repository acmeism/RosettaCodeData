NSString *path = [NSString stringWithString:@"/usr/share/dict/words"];
NSError *error = nil;
NSString *words = [[NSString alloc] initWithContentsOfFile:path
                                               encoding:NSUTF8StringEncoding error:&error];
