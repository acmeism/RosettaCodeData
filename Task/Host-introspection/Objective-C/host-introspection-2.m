switch ([NSRunningApplication currentApplication].executableArchitecture) {
  case NSBundleExecutableArchitectureI386:
    NSLog(@"%@", @"i386 32-bit");
    break;

  case NSBundleExecutableArchitectureX86_64:
    NSLog(@"%@", @"x86_64 64-bit");
    break;

  case NSBundleExecutableArchitecturePPC:
    NSLog(@"%@", @"PPC 32-bit");
    break;

  case NSBundleExecutableArchitecturePPC64:
    NSLog(@"%@", @"PPC64 64-bit");
    break;

  default:
    NSLog(@"%@", @"Unknown");
    break;
}
