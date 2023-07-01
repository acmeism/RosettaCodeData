sub kolakoski (*@seed) {
    my $k = @seed[0] == 1 ?? 1 !! 0;
    my @k = flat @seed[0] == 1 ?? (1, @seed[1] xx @seed[1]) !! @seed[0] xx @seed[0],
      { $k++; @seed[$k % @seed] xx @k[$k] } … *
}

sub rle (*@series) { @series.join.subst(/((.)$0*)/, -> { $0.chars }, :g).comb».Int }

# Testing
for [1, 2], 20,
    [2, 1], 20,
    [1, 3, 1, 2], 30,
    [1, 3, 2, 1], 30
  -> @seed, $terms {
    say "\n## $terms members of the series generated from { @seed.perl } is:\n   ",
    my @kolakoski = kolakoski(@seed)[^$terms];
    my @rle = rle @kolakoski;
    say "   Looks like a Kolakoski sequence?: ", @rle[*] eqv @kolakoski[^@rle];
}
