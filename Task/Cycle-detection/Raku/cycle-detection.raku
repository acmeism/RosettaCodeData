sub cyclical-function (\x) { (x * x + 1) % 255 };

my ( $l, $s ) = brent( &cyclical-function, 3 );

put join ', ', (3, -> \x { cyclical-function(x) } ... *)[^20], '...';
say "Cycle length $l.";
say "Cycle start index $s.";
say (3, -> \x { cyclical-function(x) } ... *)[$s .. $s + $l - 1];

sub brent (&f, $x0) {
    my $power = my $λ = 1;
    my $tortoise = $x0;
    my $hare = f($x0);
    while ($tortoise != $hare) {
        if $power == $λ {
            $tortoise = $hare;
            $power *= 2;
            $λ = 0;
        }
        $hare = f($hare);
        $λ += 1;
    }

    my $μ = 0;
    $tortoise = $hare = $x0;
    $hare = f($hare) for ^$λ;

    while ($tortoise != $hare) {
        $tortoise = f($tortoise);
        $hare = f($hare);
        $μ += 1;
    }
    return $λ, $μ;
}
