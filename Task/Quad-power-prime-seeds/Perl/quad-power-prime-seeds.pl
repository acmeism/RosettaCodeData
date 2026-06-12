use v5.36;
use bigint;
use ntheory 'is_prime';
use List::Util 'max';

sub comma { reverse ((reverse shift) =~ s/(.{3})/$1,/gr) =~ s/^,//r }
sub table ($c, @V) { my $t = $c * (my $w = 2 + max map { length } @V); ( sprintf( ('%'.$w.'s')x@V, @V) ) =~ s/.{1,$t}\K/\n/gr }

my($n,@qpps);
while (@qpps < 50) {
    my $k = 1 + ++$n;
    push @qpps, comma $n if
    is_prime($n    + $k) and
    is_prime($n**2 + $k) and
    is_prime($n**3 + $k) and
    is_prime($n**4 + $k);
}

say 'First fifty quad-power prime seeds:';
say table(10,@qpps);
