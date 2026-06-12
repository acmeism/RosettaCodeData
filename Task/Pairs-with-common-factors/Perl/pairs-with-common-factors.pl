use v5.36;
use ntheory 'factor';
use List::Util qw<sum product uniq max>;

sub comma { reverse ((reverse shift) =~ s/(.{3})/$1,/gr) =~ s/^,//r }
sub table ($c, @V) { my $t = $c * (my $w = 2 + max map {length} @V); ( sprintf( ('%'.$w.'s')x@V, @V) ) =~ s/.{1,$t}\K/\n/gr }

my($max, @phi, @n_pairs) = (100, 0);
for my $t (1..$max) { push @phi, $t * product map { 1 - 1/$_ } uniq factor($t) }
push @n_pairs, comma $_ * ($_ - 1) / 2 + 1 - sum @phi[1..$_] for 1..$max;

say 'Number of pairs with common factors - first one hundred terms:';
say table 10, @n_pairs;
