use NativeCall;
say $*VM.config<ptr_size>;
my $bytes = nativecast(CArray[uint8], CArray[uint16].new(1));
say $bytes[0] ?? "little-endian" !! "big-endian";
