sub gray_encode ( Int $n --> Int ) {
    return $n +^ ( $n +> 1 );
}

sub gray_decode ( Int $n is copy --> Int ) {
    my $mask = 1 +< (32-2);
    $n +^= $mask +> 1 if $n +& $mask while $mask +>= 1;
    return $n;
}

for ^32 -> $n {
    my $g = gray_encode($n);
    my $d = gray_decode($g);
    printf "%2d: %5b => %5b => %5b: %2d\n", $n, $n, $g, $d, $d;
    die if $d != $n;
}
