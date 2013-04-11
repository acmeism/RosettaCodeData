sub max2 (*@a) { reduce -> $x, $y { $y after $x ?? $y !! $x }, @a }
say max2 17, 13, 50, 56, 28, 63, 62, 66, 74, 54;
