use v5.36;
use experimental 'for_list';
use List::Util 'uniq';
use ntheory 'is_prime';

sub       X ($a, $b) { my @c; for my $aa (0..$a-1) { for my $bb (0..$b-1) { push @c, $aa, $bb } } @c }
sub   table ($c, @V) { my $t = $c * (my $w = 6); ( sprintf( ('%'.$w.'d')x@V, @V) ) =~ s/.{1,$t}\K/\n/gr }
sub display (@s)     { table 10, grep { $_ < 5000 } grep { not $s[$_] and 0==$_%2 and $_ } 0..@s }

my ($limit, @sums) = 10_000;
my @twins = uniq map { $_, $_+2 } grep { is_prime $_ and is_prime($_+2) } 3 .. $limit;
for my($i,$j) ( X ((scalar @twins) x 2) ) { ++$sums[ $twins[$i] + $twins[$j] ] }
say   "Non twin prime sums:\n"               . display @sums;
++$sums[1 + $_] for 1, @twins;
say "\nNon twin prime sums (including 1):\n" . display @sums;
