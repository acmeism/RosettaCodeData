subset SqMat of Array where { .elems == all(.[]».elems) }

multi infix:<*>(SqMat $a, SqMat $b) {[
    for ^$a -> $r {[
        for ^$b[0] -> $c {
            [+] ($a[$r][] Z* $b[].map: *[$c])
        }
    ]}
]}

multi infix:<**> (SqMat $m, Int $n is copy where { $_ >= 0 }) {
    my $tmp = $m;
    my $out = [for ^$m -> $i { [ for ^$m -> $j { +($i == $j) } ] } ];
    loop {
        $out = $out * $tmp if $n +& 1;
        last unless $n +>= 1;
        $tmp = $tmp * $tmp;
    }

    $out;
}

multi show (SqMat $m) {
    my $size = $m.map( *.list».chars ).flat.max;
    say .fmt("%{$size}s", ' ') for $m.list;
}

my @m = [1, 2, 0],
        [0, 3, 1],
        [1, 0, 0];

for 0 .. 10 -> $order {
    say "### Order $order";
    show @m ** $order;
}
