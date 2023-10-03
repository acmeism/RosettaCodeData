sub md4($str) {
    my buf8 $buf .= new: $str.encode;
    my $buf-length = $buf.elems;
    $buf.push: 0x80;
    $buf.push: 0 until ($buf - (448 div 8)) %% (512 div 8);
    $buf.write-uint64: $buf.elems, $buf-length*8, LittleEndian;

    my (&f, &g, &h, &r) =
      { $^x +& $^y +| +^$x +& $^z },
      { $^x +& $^y +| $x +& $^z +| $y +& $z },
      { $^x +^ $^y +^ $^z },
      # for some reason we have to type v here
      -> uint32 $v, $s { $v +< $s +| $v +> (32 - $s) }

    my uint32 ($a, $b, $c, $d) = 0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476;

    for @$buf.rotor(64) {
        my uint32 @x = .rotor(4).map: {:256[.reverse]}

        my ($aa, $bb, $cc, $dd) = $a, $b, $c, $d;
        for 0, 4, 8, 12 -> $i {
            $a = r($a + f($b, $c, $d) + @x[ $i+0 ],  3);
            $d = r($d + f($a, $b, $c) + @x[ $i+1 ],  7);
            $c = r($c + f($d, $a, $b) + @x[ $i+2 ], 11);
            $b = r($b + f($c, $d, $a) + @x[ $i+3 ], 19);
        }
        for 0, 1, 2, 3 -> $i {
            $a = r($a + g($b, $c, $d) + @x[ $i+0 ] + 0x5a827999,  3);
            $d = r($d + g($a, $b, $c) + @x[ $i+4 ] + 0x5a827999,  5);
            $c = r($c + g($d, $a, $b) + @x[ $i+8 ] + 0x5a827999,  9);
            $b = r($b + g($c, $d, $a) + @x[ $i+12] + 0x5a827999, 13);
        }
        for 0, 2, 1, 3 -> $i {
            $a = r($a + h($b, $c, $d) + @x[ $i+0 ] + 0x6ed9eba1,  3);
            $d = r($d + h($a, $b, $c) + @x[ $i+8 ] + 0x6ed9eba1,  9);
            $c = r($c + h($d, $a, $b) + @x[ $i+4 ] + 0x6ed9eba1, 11);
            $b = r($b + h($c, $d, $a) + @x[ $i+12] + 0x6ed9eba1, 15);
        }
        ($a,$b,$c,$d) Z[+=] ($aa,$bb,$cc,$dd);
    }

    my buf8 $abcd .= new;
    for $a, $b, $c, $d { $abcd.write-uint32: 4*$++, $_, LittleEndian }
    blob8.new: $abcd;
}

sub MAIN {
    my $str = 'Rosetta Code';
    say md4($str);
}
