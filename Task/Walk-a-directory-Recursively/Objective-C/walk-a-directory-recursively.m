NSString *dir = NSHomeDirectory();
NSDirectoryEnumerator *de = [[NSFileManager defaultManager] enumeratorAtPath:dir];

NSString *file;
while ((file = [de nextObject]))
  if ([[file pathExtension] isEqualToString:@"mp3"])
    NSLog(@"%@", file);
