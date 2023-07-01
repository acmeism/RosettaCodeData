my $a1 = 1;
my $a2 = 0;
my $d = 3.2;

say ' i d';

for 2 .. 13 -> $exp {
    my $a = $a1 + ($a1 - $a2) / $d;
    do {
        my $x = 0;
        my $y = 0;
        for ^2 ** $exp {
            $y = 1 - 2 * $y * $x;
            $x = $a - $x²;
        }
        $a -= $x / $y;
    } xx 10;
     $d = ($a1 - $a2) / ($a - $a1);
     ($a2, $a1) = ($a1, $a);
     printf "%2d %.8f\n", $exp, $d;
}
