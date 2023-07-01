sub check-equivalence ($a, $b) { so $a.Bag eqv $b.Bag }

sub edge-to-periphery (@a is copy) {
    return Nil unless @a.List.Bag.values.all == 2;
    my @b = @a.shift.flat;
    while @a > 1 {
        for @a.kv -> $k, $v {
            if $v[0] == @b.tail {
                @b.push: $v[1];
                @a.splice($k,1);
                last
            }
            elsif $v[1] == @b.tail {
                @b.push: $v[0];
                @a.splice($k,1);
                last
            }
        }
    }
    @b
}

say 'Perimeter format equality checks:';

for (8, 1, 3), (1, 3, 8),
    (18, 8, 14, 10, 12, 17, 19), (8, 14, 10, 12, 17, 19, 18)
  -> $a, $b {
     say "({$a.join: ', '})  equivalent to  ({$b.join: ', '})? ",
         check-equivalence($a, $b)
}

say "\nEdge to perimeter format translations:";

for ((1, 11), (7, 11), (1, 7)),
    ((11, 23), (1, 17), (17, 23), (1, 11)),
    ((8, 14), (17, 19), (10, 12), (10, 14), (12, 17), (8, 18), (18, 19)),
    ((1, 3), (9, 11), (3, 11), (1, 11))
  {
    .gist.print;
    say "  ==>  ({.&edge-to-periphery || 'Invalid edge format'})";
}
