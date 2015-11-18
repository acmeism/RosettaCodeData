sub propdivsum (\x) {
    my @l = x > 1, gather for 2 .. x.sqrt.floor -> \d {
        my \y = x div d;
        if y * d == x { take d; take y unless y == d }
    }
    [+] gather @l.deepmap(*.take);
}

for 1..20000 -> $i {
    my $j = propdivsum($i);
    say "$i $j" if $j > $i and $i == propdivsum($j);
}
