use NativeCall;

sub crc32(int32 $crc, Str $buf, int32 $len --> int32) is native('/usr/lib/libz.dylib') { * }

my $buf = 'The quick brown fox jumps over the lazy dog';
say crc32(0, $buf, $buf.chars).fmt('%08x');
