use strict;
use warnings;

sub E {
    my ($k, $n) = @_;
    my @s = map { $_ < $k ? [1] : [0] } (0..$n-1);

    my $d = $n - $k;
    $n = $k > $d ? $k : $d;
    $k = $k < $d ? $k : $d;
    my $z = $d;

    while ($z > 0 || $k > 1) {
        foreach my $i (0..$k-1) {
            push(@{$s[$i]}, @{$s[-1 - $i]});
        }
        splice(@s, -$k);
        $z -= $k;
        $d = $n - $k;
        $n = $k > $d ? $k : $d;
        $k = $k < $d ? $k : $d;
    }

    return map { @$_ } @s;
}

my $sequence = join('', E(5, 13));
print "$sequence\n";
# Expected output: 1001010010100
