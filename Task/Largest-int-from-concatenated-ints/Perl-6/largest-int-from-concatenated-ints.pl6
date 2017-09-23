sub maxnum(*@x) {
    [~] @x.sort: -> $a, $b { $b ~ $a leg $a ~ $b }
}

say maxnum <1 34 3 98 9 76 45 4>;
say maxnum <54 546 548 60>;
