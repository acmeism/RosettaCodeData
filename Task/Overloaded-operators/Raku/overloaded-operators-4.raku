sub infix:<⊕> (Int $x, Int $y) is equiv(&infix:<+>) { $x +^ $y }

sub infix:<⊗> (Int $x, Int $y) is equiv(&infix:<×>) {
    return $x × $y if so $x|$y < 2;
    my $h = exp $x.lsb, 2;
    return $h ⊗ $y ⊕ (($x ⊕ $h) ⊗ $y) if $x > $h;
    return $y ⊗ $x if $y.lsb < $y.msb;
    return $x × $y unless my $comp = $x.lsb +& $y.lsb;
    $h = exp $comp.lsb, 2;
    (($x +> $h) ⊗ ($y +> $h)) ⊗ (3 +< ($h - 1))
}

say 123 ⊗ 456;
