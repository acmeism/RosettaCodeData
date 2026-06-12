use List::Divvy;

my @tps = lazy (^Inf).hyper(:1000batch).map({next if $_%2; (my $s = .², $_, $s+>1)}).grep:
  {(.[2]-1).is-prime && (.[2]+1).is-prime};

{
    state $c;
    say "{++$c}: {.[1]}² ({.[0]}) == {.[2]-1} + {.[2]+1}"
} for @tps.&before({.[2] > 1e7});

say "{(now - INIT now).round(.001)} seconds elapsed\n";

{
    my $s =  @tps[$_];
    say "{1+$_}: {$s[1]}² ({$s[0]}) == {$s[2]-1} + {$s[2]+1}";
} for @tps.&before({.[0] > 1e12}).elems - 1, @tps.first({.[1] > 1e7},:k) - 1;

say "\n{(now - INIT now).round(.001)} total seconds elapsed\n";
