use Lingua::EN::Numbers;

sub pell (Int $n) {

    my $y = my $x = Int(sqrt $n);
    my $z = 1;
    my $r = 2 * $x;

    my ($e1, $e2) = (1, 0);
    my ($f1, $f2) = (0, 1);

    loop {
        $y = $r * $z - $y;
        $z = Int(($n - $y²) / $z);
        $r = Int(($x + $y) / $z);

        ($e1, $e2) = ($e2, $r * $e2 + $e1);
        ($f1, $f2) = ($f2, $r * $f2 + $f1);

        my $A = $e2 + $x * $f2;
        my $B = $f2;

        if ($A² - $n * $B² == 1) {
            return ($A, $B);
        }
    }
}

for 61, 109, 181, 277, 8941 -> $n {
    next if $n.sqrt.narrow ~~ Int;
    my ($x, $y) = pell($n);
    printf "x² - %sy² = 1 for:\n\tx = %s\n\ty = %s\n\n", $n, |($x, $y)».&comma;
}
