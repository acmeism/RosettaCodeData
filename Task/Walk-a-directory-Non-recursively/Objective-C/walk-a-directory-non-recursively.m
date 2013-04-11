NSString *dir = @"/foo/bar";

// Pre-OS X 10.5
NSArray *contents = [[NSFileManager defaultManager] directoryContentsAtPath:dir];
// OS X 10.5+
NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dir error:NULL];

NSEnumerator *enm = [contents objectEnumerator];
NSString *file;
while ((file = [enm nextObject]))
  if ([[file pathExtension] isEqualToString:@"mp3"])
    NSLog(@"%@", file);
