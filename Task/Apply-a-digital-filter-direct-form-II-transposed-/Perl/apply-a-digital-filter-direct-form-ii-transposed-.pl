use strict;
use List::AllUtils 'natatime';

sub TDF_II_filter {
    our(@signal,@a,@b);
    local(*signal,*a,*b) = (shift, shift, shift);
    my @out = (0) x $#signal;
    for my $i (0..@signal-1) {
        my $this;
        map { $this += $b[$_] * $signal[$i-$_] if $i-$_ >= 0 } 0..@b;
        map { $this -= $a[$_] *    $out[$i-$_] if $i-$_ >= 0 } 0..@a;
        $out[$i] = $this / $a[0];
    }
    @out
}

my @signal = (
    -0.917843918645,  0.141984778794, 1.20536903482,   0.190286794412,
    -0.662370894973, -1.00700480494, -0.404707073677,  0.800482325044,
     0.743500089861,  1.01090520172,  0.741527555207,  0.277841675195,
     0.400833448236, -0.2085993586,  -0.172842103641, -0.134316096293,
     0.0259303398477, 0.490105989562, 0.549391221511,  0.9047198589
);
my @a = ( 1.00000000, -2.77555756e-16, 3.33333333e-01, -1.85037171e-17 );
my @b = ( 0.16666667,  0.5,            0.5,             0.16666667     );

my @filtered = TDF_II_filter(\@signal, \@a, \@b);
my $iter = natatime 5, @filtered;
while( my @values = $iter->() ) {
    printf(' %10.6f' x 5 . "\n", @values);
}
