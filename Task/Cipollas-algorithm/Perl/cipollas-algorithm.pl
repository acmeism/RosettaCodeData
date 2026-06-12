use bigint;
use ntheory qw(is_prime);

sub Legendre {
    my($n,$p) = @_;
    return -1 unless $p != 2 && is_prime($p);
    my $x = ($n->as_int())->bmodpow(int(($p-1)/2), $p); # $n coerced to BigInt
    if    ($x==0) { return  0 }
    elsif ($x==1) { return  1 }
    else          { return -1 }
}

sub Cipolla {
    my($n, $p) = @_;
    return undef if Legendre($n,$p) != 1;

    my $w2;
    my $a = 0;
    $a++ until Legendre(($w2 = ($a**2 - $n) % $p), $p) < 0;

    my %r = ( x=> 1,  y=> 0 );
    my %s = ( x=> $a, y=> 1 );
    my $i = $p + 1;
    while (1 <= ($i >>= 1)) {
        %r = ( x => (($r{x} * $s{x} + $r{y} * $s{y} * $w2) % $p),
               y => (($r{x} * $s{y} + $s{x} * $r{y})       % $p)
             ) if $i % 2;
        %s = ( x => (($s{x} * $s{x} + $s{y} * $s{y} * $w2) % $p),
               y => (($s{x} * $s{y} + $s{x} * $s{y})       % $p)
             )
    }
    $r{y} ? undef : $r{x}
}

my @tests = (
    (10, 13),
    (56, 101),
    (8218, 10007),
    (8219, 10007),
    (331575, 1000003),
    (665165880, 1000000007),
    (881398088036, 1000000000039),
);

while (@tests) {
   $n = shift @tests;
   $p = shift @tests;
   my $r = Cipolla($n, $p);
   $r ? printf "Roots of %d are (%d, %d) mod %d\n", $n, $r, $p-$r, $p
      : print  "No solution for ($n, $p)\n"
}
