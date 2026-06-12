use v5.36;
use bigint;
use experimental <builtin for_list>;
use ntheory <is_prime vecfirstidx>;

sub X     ($a, $b) { my @c; for my $aa (0..$a) { for my $bb (0..$b) { push @c, $aa, $bb } } @c }
sub table ($c, @V) { my $t = $c * (my $w = 6); ( sprintf( ('%'.$w.'d')x@V, @V) ) =~ s/.{1,$t}\K/\n/gr }

my $max = 2**53;

my(@pairs,@U);
for my($i,$j) ( X(9,9) ) { push @pairs, $i . $j unless $i == 0 || $i == $j }
for my $l (3..length $max) {
    if (0 == $l%2) { push @U, "$_"x( $l   /2) for @pairs }
    else           { push @U, "$_"x(($l+1)/2) and chop $U[-1] for @pairs }
}

say "All 3 digit undulating numbers:"; say table 9, grep { 3 == length $_ } @U;
say "All 3 digit undulating primes:";  say table 9, grep { 3 == length $_ and is_prime $_ } @U;
say "All 4 digit undulating numbers:"; say table 9, grep { 4 == length $_ } @U;

my $fmt = "%34s: %d\n";
printf $fmt, 'The 600th undulating number is', $U[599];
printf $fmt, 'Undulating numbers less than 2**53', (my $i = vecfirstidx { $_ >= $max } @U);
printf $fmt, 'That number is', $U[$i-1];
