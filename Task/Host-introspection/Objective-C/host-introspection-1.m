switch (NSHostByteOrder()) {
  case NS_BigEndian:
    NSLog(@"%@", @"Big Endian");
    break;
  case NS_LittleEndian:
    NSLog(@"%@", @"Little Endian");
    break;
  case NS_UnknownByteOrder:
    NSLog(@"%@", @"endianness unknown");
    break;
}
