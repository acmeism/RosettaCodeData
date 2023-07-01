use 5.010;
use List::Util qw(sum);
use Math::BigRat try => 'GMP';
use ntheory qw(binomial bernfrac);

sub faulhaber_triangle {
    my ($p) = @_;
    map {
        Math::BigRat->new(bernfrac($_))
          * binomial($p, $_)
          / $p
    } reverse(0 .. $p-1);
}

# First 10 rows of Faulhaber's triangle
foreach my $p (1 .. 10) {
    say map { sprintf("%6s", $_) } faulhaber_triangle($p);
}

# Extra credit
my $p = 17;
my $n = Math::BigInt->new(1000);
my @r = faulhaber_triangle($p+1);
say "\n", sum(map { $r[$_] * $n**($_ + 1) } 0 .. $#r);
