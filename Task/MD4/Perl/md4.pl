sub md4(@) {
    my @input = grep { defined && length > 0 } split /(.{64})/s, join '', @_;
    push @input, '' if !@input || length($input[$#input]) >= 56;

    my @A = (0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476); # initial regs
    my @T = (0, 0x5A827999, 0x6ED9EBA1);
    my @L = qw(3 7 11 19 3 5 9 13 3 9 11 15);   # left rotate counts
    my @O = (1, 4, 4,                           # x stride for input index
             4, 1, 1,                           # y stride for input index
             0, 0, 1);                          # bitwise reverse both indexes
    my @I = map {
                    my $z   = int $_/16;
                    my $x   = $_%4;
                    my $y   = int $_%16/4;
                    ($x,$y) = (R($x),R($y)) if $O[6+$z];
                    $O[$z] * $x + $O[3+$z] * $y
                } 0..47;

    my ($a,$b,$c,$d);
    my($l,$p) = (0,0);
    foreach (@input) {
        my $r = length($_);
        $l += $r;
        $r++, $_.="\x80" if $r<64 && !$p++;
        my @W = unpack 'V16', $_ . "\0"x7;
        push @W, (0)x16 if @W < 16;
        $W[14] = $l*8 if $r < 57;              # add bit-length in low 32-bits
        ($a,$b,$c,$d) = @A;
        for (0..47) {
            my $z = int $_/16;
            $a = L($L[4*($_>>4) + $_%4],
                 M(&{(sub{$b&$c|~$b&$d},       # F
                      sub{$b&$c|$b&$d|$c&$d},  # G
                      sub{$b^$c^$d}            # H
                     )[$z]}
                   + $a + $W[$I[$_]] + $T[$z]));
            ($a,$b,$c,$d) = ($d,$a,$b,$c);
        }
        my @v = ($a, $b, $c, $d);
        $A[$_] = M($A[$_] + $v[$_]) for 0..3;
    }
    pack 'V4', @A;
}

sub L { # left-rotate
    my ($n, $x) = @_;
    $x<<$n | 2**$n - 1 & $x>>(32-$n);
}

sub M { # mod 2**32
    no integer;
    my ($x) = @_;
    my $m = 1+0xffffffff;
    $x - $m * int $x/$m;
}

sub R { # reverse two bit number
    my $n = pop;
    ($n&1)*2 + ($n&2)/2;
}

sub md4_hex(@) { # convert to hexadecimal
  unpack 'H*', &md4;
}

print "Rosetta Code => " . md4_hex( "Rosetta Code" ) . "\n";
