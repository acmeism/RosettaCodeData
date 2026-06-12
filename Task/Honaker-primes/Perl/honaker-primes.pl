use v5.36;
use ntheory 'nth_prime';
use List::Util <max sum>;

sub table ($c, @V) { my $t = $c * (my $w = 2 + max map { length } @V); ( sprintf( ('%'.$w.'s')x@V, @V) ) =~ s/.{1,$t}\K/\n/gr }
sub comma { scalar reverse join ',', unpack '(A3)*', reverse shift }

my($n,@honaker);

while () {
    my $p = nth_prime(++$n);
    push @honaker, [$n, $p] if (sum split '', $p) == sum split '', $n;
    last if 10_000 == @honaker;
}

push @res, "First 50 Honaker primes (index, prime):";
push @res, table 5, map { sprintf "(%3d, %4d)", @$_ } @honaker[0..49];

push @res, "Ten thousandth: " . sprintf "(%s, %s)", map { comma $_ } @{$honaker[9999]};
