use Prime::Factor;

my @fact = 1, |[\*] 1..*;

sub kempner (Int $n where * > 0) {
    return 1 if $n == 1;
    my $bag = $n.&prime-factors.BagHash;
    for $bag.keys -> $k {
        my $v = exp $bag{$k}, $k;
        next if $k² >= $v;
        $bag{$k} = (@fact.first: {$_ %% $v}, :k) div $k;
    }
    max $bag.map: { .key * .value }
}

say 'First fifty Kempner numbers:';
say (1..50).map( { .&kempner.fmt: "%3d" } ).batch(10).join: "\n";
say '';
.put for (77135679311..77135679321).map: { "S($_)", .&kempner };
