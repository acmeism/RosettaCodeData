use NativeCall;

sub crc32(int32 $crc, Buf $buf, int32 $len --> int32) is native('z') { * }

my $buf = 'The quick brown fox jumps over the lazy dog'.encode;
say crc32(0, $buf, $buf.bytes).fmt('%08x');
