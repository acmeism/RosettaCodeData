sub msb64 {
  my($n, $pos) = (shift, 0);
  die "n must be a 64-bit integer)" if $n > ~0;
  no warnings 'portable';  # Remove this and adjust lines for 32-bit
  if (($n & 0xFFFFFFFF00000000) == 0) { $pos += 32; $n <<= 32; }
  if (($n & 0xFFFF000000000000) == 0) { $pos += 16; $n <<= 16; }
  if (($n & 0xFF00000000000000) == 0) { $pos +=  8; $n <<=  8; }
  if (($n & 0xF000000000000000) == 0) { $pos +=  4; $n <<=  4; }
  if (($n & 0xC000000000000000) == 0) { $pos +=  2; $n <<=  2; }
  if (($n & 0x8000000000000000) == 0) { $pos +=  1; $n <<=  1; }
  63-$pos;
}
