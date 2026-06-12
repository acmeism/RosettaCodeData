use v5.36;
use ntheory 'factor';
use List::Util <min max>;

sub table ($c, @V) { my $t = $c * (my $w = 2 + length max @V); ( sprintf( ('%'.$w.'d')x@V, @V) ) =~ s/.{1,$t}\K/\n/gr }

my @p = 1;
for (2..100) {
    my @f = factor $_;
    push @p, min(@f) * max(@f);
}

say "Product of smallest and greatest prime factors of n for 1 to 100:\n" . table 10, @p;
