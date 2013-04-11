my $POW = 20;
my $top = 2**$POW;

my @a = (0,1,1);
@a[$top] = 0;   # pre-extend array

my $n = 3;
my $p = 1;

loop ($n = 3; $n <= $top; $n++) {
    @a[$n] = $p = @a[$p] + @a[$n - $p];
}

my $last55;
for 1 ..^ $POW -> $power {

    my $beg = 2 ** $power;
    my $end = $beg * 2 - 1;
    my $max;
    my $ratio;

    loop (my $n = $beg; $n <= $end; $n++) {
        my $ratio = @a[$n] / $n;
        $last55 = $n if $ratio * 100 >= 55;
        $max max= $ratio => $n;
    }

    say $power.fmt('%2d'), $beg.fmt("%10d"), '..', $end.fmt("%-10d"), $max.key, " at ", $max.value;
}
say "Mallows' number would appear to be ", $last55;
