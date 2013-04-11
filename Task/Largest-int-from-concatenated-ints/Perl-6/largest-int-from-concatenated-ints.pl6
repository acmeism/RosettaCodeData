sub maxnum(@x) {
    [~] sort -> $x, $y { $x~$y <=> $y~$x }, @x
}

say maxnum .[] for
[<1 34 3 98 9 76 45 4>],
[<54 546 548 60>];
