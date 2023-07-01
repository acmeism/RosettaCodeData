use v5.36;
use List::Util 'min';

my($limit, $maxS, $length, $p, @s) = (150, 1, 2, 3);

sub next_($w) { $s[$w-1] }
sub prev_($w) { $s[$w-2] }

sub append($w) {
    $s[$maxS-1] = $w;
    $s[$w-2]    = $maxS;
    $maxS       = $w;
}

sub delete_multiples_of($p) {
    my $f = $p;
    while ($p*$f <= $length) { $f = next_ $f                   }
    while (   $f >  1      ) { $f = prev_ $f; delete_pf($p*$f) }
}

sub delete_pf($pf) {
    my($temp1, $temp2) = ($s[$pf-2], $s[$pf-1]);
    $s[ $temp1-1    ] = $temp2;
    $s[($temp2-2)%@s] = $temp1;
}

sub extend_to($n) {
    my($w, $x) = (1, $length+1);
    while ($x <= $n) {
        append $x;
        $w = next_ $w;
        $x = $length + $w;
    }
    $length = $n;
    append $limit+2 if $length == $limit
}

do {
    extend_to min $p*$length, $limit if $length < $limit;
    delete_multiples_of $p;
    $p = next_ 1;
    extend_to $limit if $length < $limit
} until $p*$p > $limit;

my @primes = 2;
for (my $p = 3; $p <= $limit; $p = next_ $p) { push @primes, $p }
say "@primes";
