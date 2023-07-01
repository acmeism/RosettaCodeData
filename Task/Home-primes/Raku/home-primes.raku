use Prime::Factor;

my $start = now;

(flat 2..20, 65).map: -> $m {
    my ($now, @steps, @factors) = now, $m;

    @steps.push: @factors.join('_') while (@factors = prime-factors @steps[*-1].Int) > 1;

    say (my $step = +@steps) > 1 ?? (@steps[0..*-2].map( { "HP$_\({--$step})" } ).join: ' = ') !! ("HP$m"),
      " = ", @steps[*-1], "  ({(now - $now).fmt("%0.3f")} seconds)";
}

say "Total elapsed time: {(now - $start).fmt("%0.3f")} seconds\n";

say 'HP49:';
my ($now, @steps, @factors) = now, 49;
my $step = 0;
while (@factors = prime-factors @steps[*-1].Int) > 1 {
    @steps.push: @factors.join('_');
    say "HP{@steps[$step].Int}\(n - {$step++}) = ", @steps[*-1], "  ({(now - $now).fmt("%0.3f")} seconds)";
    $now = now;
    last if $step > 30;
}
