use 5.010;

# usage: script X Y Z [S]

sub cuboid {

    # Constant dimnesions of the cuboid
    my ($x, $y, $z) = map int, @_[0 .. 2];

    # ASCII characters
    # $c = corner point
    # $h = horizontal line
    # $v = vertical line
    # $d = diagonal line
    # $s = space (inside the cuboid)
    my ($c, $h, $v, $d, $s) = ('+', '-', '|', '/', shift(@ARGV) // q{ });

    say q{ } x ($z + 1), $c, $h x $x, $c;
    say q{ } x ($z - $_ + 1), $d, $s x $x, $d, $s x ($_ - ($_ > $y ? ($_ - $y) : 1)),
      $_ - 1 == $y ? $c : $_ > $y ? $d : $v for 1 .. $z;
    say $c, $h x $x, $c, ($s x ($z < $y ? $z : $y), $z < $y ? $v : $z == $y ? $c : $d);
    say $v, $s x $x, $v, $z > $y ? $_ >= $z ? ($s x $x, $c) : ($s x ($y - $_), $d)
      : $y - $_ > $z ? ($s x $z, $v) : ($s x ($y - $_), $y - $_ == $z ? $c : $d) for 1 .. $y;
    say $c, $h x $x, $c;
}

cuboid shift // rand 20, shift // rand 10, shift // rand 10;
