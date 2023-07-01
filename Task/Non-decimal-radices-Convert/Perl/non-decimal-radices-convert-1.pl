sub to2  { sprintf "%b", shift; }
sub to16 { sprintf "%x", shift; }
sub from2  { unpack("N", pack("B32", substr("0" x 32 . shift, -32))); }
sub from16 { hex(shift); }
