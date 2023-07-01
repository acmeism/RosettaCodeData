use strict;
use warnings;
use enum qw(False True);
use ntheory qw/divisor_sum is_prime/;

sub sieve {
    my($n) = @_;
    my %s;
    for my $k (0 .. $n+1) {
        my $sum = divisor_sum($k) - $k;
        $s{$sum} = True if $sum <= $n+1;
    }
    %s
}

my(%s,%c);
my($max, $limit, $cnt) = (2000, 1e5, 0);

%s = sieve 14 * $limit;
!is_prime($_) and $c{$_} = True for 1..$limit;
my @untouchable = (2, 5);
for ( my $n = 6; $n <= $limit; $n += 2 ) {
   push @untouchable, $n if !$s{$n} and $c{$n-1} and $c{$n-3};
}
map { $cnt++ if $_ <= $max } @untouchable;
print "Number of untouchable numbers ≤ $max : $cnt \n\n" .
      (sprintf "@{['%6d' x $cnt]}", @untouchable[0..$cnt-1]) =~ s/(.{84})/$1\n/gr .  "\n";

my($p, $count) = (10, 0);
my $fmt = "%6d untouchable numbers were found  ≤ %7d\n";
for my $n (@untouchable) {
   $count++;
   if ($n > $p) {
      printf $fmt, $count-1, $p;
      printf($fmt, scalar @untouchable, $limit) and last if $limit == ($p *= 10)
   }
}
