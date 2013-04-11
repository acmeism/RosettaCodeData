enum RedBlack <R B>;

multi balance(B,[R,[R,$a,$x,$b],$y,$c],$z,$d) { [R,[B,$a,$x,$b],$y,[B,$c,$z,$d]] }
multi balance(B,[R,$a,$x,[R,$b,$y,$c]],$z,$d) { [R,[B,$a,$x,$b],$y,[B,$c,$z,$d]] }
multi balance(B,$a,$x,[R,[R,$b,$y,$c],$z,$d]) { [R,[B,$a,$x,$b],$y,[B,$c,$z,$d]] }
multi balance(B,$a,$x,[R,$b,$y,[R,$c,$z,$d]]) { [R,[B,$a,$x,$b],$y,[B,$c,$z,$d]] }

multi balance($col, $a, $x, $b) { [$col, $a, $x, $b] }

multi ins( $x, @s [$col, $a, $y, $b] ) {
    when $x before $y     { balance $col, ins($x, $a), $y, $b }
    when $x after $y      { balance $col, $a, $y, ins($x, $b) }
    default               { @s }
}
multi ins( $x, Any:U ) { [R, Any, $x, Any] }

multi insert( $x, $s ) {
    [B, ins($x,$s)[1..3]];
}

sub MAIN {
    my $t = Any;
    $t = insert($_, $t) for (1..10).pick(*);
    say $t.perl;
}
