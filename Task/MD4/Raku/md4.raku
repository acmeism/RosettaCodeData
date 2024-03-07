sub md4($str) {
    my buf8 $buf .= new: $str.encode;
    my $buf-length = $buf.elems;
    $buf.push: 0x80;
    $buf.push: 0 until ($buf - (448 div 8)) %% (512 div 8);
    # raku serializes in little endian by default
    $buf.write-uint64: $buf.elems, $buf-length*8;

    my (&f, &g, &h, &r) =
      { $^x +& $^y +| +^$x +& $^z },
      { $^x +& $^y +| $x +& $^z +| $y +& $z },
      { $^x +^ $^y +^ $^z },
      # for some reason we have to type v here
      -> uint32 $v, $s { $v +< $s +| $v +> (32 - $s) }

    my uint32 ($a, $b, $c, $d) = 0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476;

    loop (my $pos = 0; $pos < $buf.elems; $pos+=64) {
        my ($aa, $bb, $cc, $dd) = $a, $b, $c, $d;
        for 0, 4, 8, 12 -> $i {
            $a = r($a + f($b, $c, $d) + $buf.read-uint32($pos+($i+0)*4),  3);
            $d = r($d + f($a, $b, $c) + $buf.read-uint32($pos+($i+1)*4),  7);
            $c = r($c + f($d, $a, $b) + $buf.read-uint32($pos+($i+2)*4), 11);
            $b = r($b + f($c, $d, $a) + $buf.read-uint32($pos+($i+3)*4), 19);
        }
        for 0, 1, 2, 3 -> $i {
            $a = r($a + g($b, $c, $d) + $buf.read-uint32($pos+($i+0 )*4) + 0x5a827999,  3);
            $d = r($d + g($a, $b, $c) + $buf.read-uint32($pos+($i+4 )*4) + 0x5a827999,  5);
            $c = r($c + g($d, $a, $b) + $buf.read-uint32($pos+($i+8 )*4) + 0x5a827999,  9);
            $b = r($b + g($c, $d, $a) + $buf.read-uint32($pos+($i+12)*4) + 0x5a827999, 13);
        }
        for 0, 2, 1, 3 -> $i {
            $a = r($a + h($b, $c, $d) + $buf.read-uint32($pos+($i+0 )*4) + 0x6ed9eba1,  3);
            $d = r($d + h($a, $b, $c) + $buf.read-uint32($pos+($i+4 )*4) + 0x6ed9eba1,  9);
            $c = r($c + h($d, $a, $b) + $buf.read-uint32($pos+($i+8 )*4) + 0x6ed9eba1, 11);
            $b = r($b + h($c, $d, $a) + $buf.read-uint32($pos+($i+12)*4) + 0x6ed9eba1, 15);
        }
        ($a,$b,$c,$d) Z[+=] ($aa,$bb,$cc,$dd);
    }

    reduce { $^buf.write-uint32: $buf.elems, $^x; $buf }, buf8.new, $a, $b, $c, $d;
}

CHECK {
  use Test;
  plan 1;
  is md4('Rosetta Code').list.fmt('%02X'), 'A5 2B CF C6 A0 D0 D3 00 CD C5 DD BF BE FE 47 8B';
}
