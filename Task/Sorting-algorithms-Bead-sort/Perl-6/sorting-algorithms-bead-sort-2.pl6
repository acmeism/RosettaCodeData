sub beadsort(*@list) {
    my @rods;
    for words ^«@list -> $x { @rods[$x].push(1) }
    gather for ^@rods[0] -> $y {
        take [+] @rods.map: { .[$y] // last }
    }
}

say beadsort 2,1,3,5;
