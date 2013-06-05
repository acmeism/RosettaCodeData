sub md4($str) {
    my @buf = $str.ords;
    my $buflen = @buf.elems;

    my \mask = (1 +< 32) - 1;
    my &f = -> $x, $y, $z { ($x +& $y) +| ($x +^ mask) +& $z }
    my &g = -> $x, $y, $z { ($x +& $y) +| ($x +& $z) +| ($y +& $z) }
    my &h = -> $x, $y, $z { $x +^ $y +^ $z }
    my &r = -> $v, $s { (($v +< $s) +& mask) +| (($v +& mask) +> (32 - $s)) }

    sub pack-le (@a) {
        gather for @a -> $a,$b,$c,$d { take $d +< 24 + $c +< 16 + $b +< 8 + $a }
    }

    my ($a, $b, $c, $d) = 0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476;

    my $term = False;
    my $last = False;
    my $off = 0;
    repeat until $last {
        my @block = @buf[$off..$off+63]:v; $off += 64;

        my @x;
        given +@block {
	    when 64 {
	        @x = pack-le @block;
	    }
	    when 56..63 {
	        $term = True;
	        @block.push(0x80);
	        @block.push(0 xx 63 - $_);
	        @x = pack-le @block;
	    }
	    when 0..55 {
	        @block.push($term ?? 0 !! 0x80);
	        @block.push(0 xx 55 - $_);
	        @x = pack-le @block;
	
	        my $bit_len = $buflen +< 3;
	        @x.push: $bit_len +& mask, $bit_len +> 32;
	        $last = True;
	    }
	    default {
	        die "oops";
	    }
	}

	my ($aa, $bb, $cc, $dd) = $a, $b, $c, $d;
	for 0, 4, 8, 12 -> \i {
	    $a = r($a + f($b, $c, $d) + @x[ i+0 ],  3);
	    $d = r($d + f($a, $b, $c) + @x[ i+1 ],  7);
	    $c = r($c + f($d, $a, $b) + @x[ i+2 ], 11);
	    $b = r($b + f($c, $d, $a) + @x[ i+3 ], 19);
	}
	for 0, 1, 2, 3 -> \i {
	    $a = r($a + g($b, $c, $d) + @x[ i+0 ] + 0x5a827999,  3);
	    $d = r($d + g($a, $b, $c) + @x[ i+4 ] + 0x5a827999,  5);
	    $c = r($c + g($d, $a, $b) + @x[ i+8 ] + 0x5a827999,  9);
	    $b = r($b + g($c, $d, $a) + @x[ i+12] + 0x5a827999, 13);
	}
	for 0, 2, 1, 3 -> \i {
	    $a = r($a + h($b, $c, $d) + @x[ i+0 ] + 0x6ed9eba1,  3);
	    $d = r($d + h($a, $b, $c) + @x[ i+8 ] + 0x6ed9eba1,  9);
	    $c = r($c + h($d, $a, $b) + @x[ i+4 ] + 0x6ed9eba1, 11);
	    $b = r($b + h($c, $d, $a) + @x[ i+12] + 0x6ed9eba1, 15);
	}
	$a = ($a + $aa) +& mask;
	$b = ($b + $bb) +& mask;
	$c = ($c + $cc) +& mask;
	$d = ($d + $dd) +& mask;
    }

    sub b2l($n is copy) {
	my $x = 0;
	for ^4 {
	    $x +<= 8;
	    $x += $n +& 0xff;
	    $n +>= 8;
	}
	$x;
    }

    b2l($a) +< 96 +
    b2l($b) +< 64 +
    b2l($c) +< 32 +
    b2l($d);
}

sub MAIN {
    my $str = 'Rosetta Code';
    say md4($str).base(16).lc;
}
