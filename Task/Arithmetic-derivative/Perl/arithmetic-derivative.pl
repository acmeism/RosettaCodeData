use v5.36;
use bigint;
no warnings 'uninitialized';
use List::Util 'max';
use ntheory 'factor';

sub table ($c, @V) { my $t = $c * (my $w = 2 + length max @V); ( sprintf( ('%'.$w.'d')x@V, @V) ) =~ s/.{1,$t}\K/\n/gr }

sub D ($n) {
    my(%f, $s);
    $f{$_}++ for factor max 1, my $nabs = abs $n;
    map { $s += $nabs * $f{$_} / $_ } keys %f;
    $n > 0 ? $s : -$s;
}

say table 10, map { D $_ } -99 .. 100;
say join "\n", map { sprintf('D(10**%-2d) / 7 == ', $_) . D(10**$_) / 7 } 1 .. 20;
