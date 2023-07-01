use strict;
use warnings;
use ntheory 'powmod';

sub curzon {
    my($base,$cnt) = @_;
    my($n,@C) = 0;
    while (++$n) {
        my $r = $base * $n;
        push @C, $n if powmod($base, $n, $r + 1) == $r;
        return @C if $cnt == @C;
    }
}

my $upto = 50;
for my $k (<2 4 6 8 10>) {
    my @C = curzon $k, 1000;
    print "First $upto Curzon numbers using a base of $k:\n" .
    (sprintf "@{['%5d' x $upto]}", @C[0..$upto-1]) =~ s/.{100}/$&\n/gr;
    printf "%50s\n\n", "Thousandth: $C[-1]"
}
