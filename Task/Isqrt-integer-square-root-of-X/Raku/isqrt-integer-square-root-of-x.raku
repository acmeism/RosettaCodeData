use Lingua::EN::Numbers;

sub isqrt ( \x ) { my ( $X, $q, $r, $t ) =  x, 1, 0 ;
    $q +<= 2 while $q ≤ $X ;
    while $q > 1 {
        $q +>= 2; $t = $X - $r - $q; $r +>= 1;
        if $t ≥ 0 { $X = $t; $r += $q }
    }
    $r
}

say (^66)».&{ isqrt $_ }.Str ;

(1, 3…73)».&{ "7**$_: " ~ comma(isqrt 7**$_) }».say
