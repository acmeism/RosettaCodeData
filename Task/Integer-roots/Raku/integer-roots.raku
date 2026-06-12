sub integer_root ( Int $p where * >= 2, Int $n --> Int ) {
    my Int $d = $p - 1;
    (
      10**($n.chars div $p),
      { ( $d * $^x   +   $n div ($x ** $d) ) div $p } ...
      -> $a, $, $c { $a == $c }
    ).tail(2).min;
}

say integer_root( 2, 2 * 100 ** 2000 );
