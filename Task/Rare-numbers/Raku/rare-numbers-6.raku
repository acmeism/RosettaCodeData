use NativeCall;

constant LIB = '/home/hkdtam/Rare/target/debug/libRare.so';

sub advanced64(uint8) returns Pointer[uint64] is native(LIB) {*}

my $N = 5;
say "The first $N rare numbers are,";

for (advanced64 $N)[^$N].kv -> \nth,\rare {
   printf "%d: %12d reverse %d\n", nth+1, { $_, $_.flip }(rare)
}
