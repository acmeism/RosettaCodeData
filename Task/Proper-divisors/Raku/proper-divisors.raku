sub propdiv (\x) {
    my @l = 1 if x > 1;
    (2 .. x.sqrt.floor).map: -> \d {
        unless x % d { @l.push: d; my \y = x div d; @l.push: y if y != d }
    }
    @l
}

put "$_ [{propdiv($_)}]" for 1..10;

my @candidates;
loop (my int $c = 30; $c <= 20_000; $c += 30) {
#(30, *+30 …^ * > 500_000).race.map: -> $c {
    my \mx = +propdiv($c);
    next if mx < @candidates - 1;
    @candidates[mx].push: $c
}

say "max = {@candidates - 1}, candidates = {@candidates.tail}";
