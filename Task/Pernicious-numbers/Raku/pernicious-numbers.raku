sub is-pernicious(Int $n --> Bool) {
    is-prime [+] $n.base(2).comb;
}

say (grep &is-pernicious, 0 .. *)[^25];
say grep &is-pernicious, 888_888_877 .. 888_888_888;
