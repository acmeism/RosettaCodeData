sub gosper (\x) {
    my \c = x +& -x;
    my \r = x + c;
    (((r +^ x) +> 2) / c) +| r
}

for 1..6 -> $bits {
    my @g = :2(1 x $bits), { gosper $_ } … *;
    say @g[^11].fmt('%8d');
    say @g[^11].fmt('%08b');
    say '';
}
