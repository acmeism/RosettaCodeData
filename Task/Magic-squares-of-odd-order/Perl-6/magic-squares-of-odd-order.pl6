sub MAIN (Int $n = 5) {

    note "Sorry, must be a positive odd integer." and exit if $n %% 2 or $n < 0;

    my $x = $n/2;
    my $y = 0;
    my $i = 1;
    my @sq;

    @sq[($i % $n ?? $y-- !! $y++) % $n][($i % $n ?? $x++ !! $x) % $n] = $i++ for ^($n * $n);

    my $f = "%{$i.chars}d";
    say .fmt($f, ' ') for @sq;

    say "\nThe magic number is ", [+] @sq[0].list;
}
