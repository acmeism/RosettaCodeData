multi bin_to_gray ( [] ) { [] }
multi bin_to_gray ( [$head, *@tail] ) {
    return [ $head, ( @tail Z+^ ($head, @tail) ) ];
}

multi gray_to_bin ( [] ) { [] }
multi gray_to_bin ( [$head, *@tail] ) {
    my @bin := $head, (@tail Z+^ @bin);
    return @bin.flat;
}

for ^32 -> $n {
    my @b = $n.fmt('%b').comb;
    my $g = bin_to_gray(@b);
    my $d = gray_to_bin($g);
    printf "%2d: %5s => %5s => %5s: %2d\n",
            $n, @b.join, $g.join, $d.join, :2($d.join);
    die if :2($d.join) != $n;
}
