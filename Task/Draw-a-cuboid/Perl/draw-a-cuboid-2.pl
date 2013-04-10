use 5.010;

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

    # Some variables
    my ($p, $o) = (0, 0);

    say q{ } x ($z + 1), $c, $h x $x, $c;
    say q{ } x ($z - $_ + 1), $d, $s x $x, $d, $s x ($_ - 1 - $p),
      $_ > $y ? !$p && ++$p ? do { $o = $z - $y; $c } : $p++ ? $d : $c : $v
      for 1 .. $z;
    say $c, $h x $x, $c, $p ? ($s x ($z - $o), $d) : ($s x $z, $z < $y ? $v : $c);
    say $v, $s x $x, $v, $z - 1 >= $y
      ? $_ >= $z
          ? ($s x $x, $c)
          : ($s x ($z - $_ - $o), $d)
      : $y - $_ > $z ? ($s x $z, $v)
      : ($s x ($y - $_), $y - $_ == $z ? $c : $d)
      for 1 .. $y;
    say $c, $h x $x, $c;
}

cuboid shift // rand 20, shift // rand 10, shift // rand 10;
