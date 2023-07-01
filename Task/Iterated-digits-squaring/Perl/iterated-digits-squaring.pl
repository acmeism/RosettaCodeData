use warnings;
use strict;

my @sq = map { $_ ** 2 } 0 .. 9;
my %cache;
my $cnt = 0;

sub Euler92 {
    my $n = 0 + join( '', sort split( '', shift ) );
    $cache{$n} //= ($n == 1 || $n == 89) ? $n :
    Euler92( sum( @sq[ split '', $n ] ) )
}

sub sum {
   my $sum;
   $sum += shift while @_;
   $sum;
}

for (1 .. 100_000_000) {
   ++$cnt if Euler92( $_ ) == 89;
}

print $cnt;
