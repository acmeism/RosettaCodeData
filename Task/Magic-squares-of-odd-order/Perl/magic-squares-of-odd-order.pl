sub magic_square {
    my $n = shift;
    my $i = 0;
    my $j = $n / 2;
    my @magic_square;

    for my $l ( 1 .. $n**2 ) {
        $magic_square[$i][$j] = $l;

        if ( $magic_square[ ( $i - 1 ) % $n ][ ( $j + 1 ) % $n ] ) {
            $i = ( $i + 1 ) % $n;
        }
        else {
            $i = ( $i - 1 ) % $n;
            $j = ( $j + 1 ) % $n;
        }
    }
    return @magic_square;
}

my $n = 7;

for ( magic_square($n) ) {
    printf '%8d' x $n . qq{\n}, @{$_};
}
