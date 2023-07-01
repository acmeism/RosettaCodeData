use NativeCall;

constant PROT_READ   = 0x1;   #
constant PROT_WRITE  = 0x2;   #
constant PROT_EXEC   = 0x4;   # from local /usr/include/bits/mman.h
constant MAP_PRIVATE = 0x02;  #
constant MAP_ANON    = 0x20;  #

sub mmap(Pointer $addr, size_t $length, int32 $prot, int32 $flags,
   int32 $fd, size_t $offset --> Pointer) is native { * };
sub memcpy(Pointer $dest, Pointer $src, size_t $size --> Pointer) is native {*}
sub munmap(Pointer $addr, size_t $length) is native { * };

sub test (uint8 $a, uint8 $b) {
   my $code = CArray[uint8].new(
      0x90, 0x90, 0x6A, 0xC, 0xB8, 0x7, 0x0, 0x0, 0x0, 0x48, 0xC1, 0xE0, 0x20,
      0x50, 0x8B, 0x44, 0x24, 0x4, 0x3, 0x44, 0x24, 0x8, 0x4C, 0x89, 0xE3, 0x89,
      0xC3, 0x48, 0xC1, 0xE3, 0x4, 0x80, 0xCB, 0x2, 0x48, 0x83, 0xC4, 0x10, 0xC3
   );
   my $buf =
      mmap(Pointer, nativesizeof($code), PROT_READ +| PROT_WRITE +| PROT_EXEC,
      MAP_PRIVATE +| MAP_ANON, -1, 0);

   memcpy($buf, nativecast(Pointer,$code), nativesizeof($code));

   my $c; # = ((int (*) (int, int))buf)(a, b);

   munmap($buf, nativesizeof($code));

   return $c = "Incomplete Attempt";
}

say test 7, 12;
