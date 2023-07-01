sub det(@matrix) {
    my @a     = @matrix.map: { [|$_] };
    my $sign  = 1;
    my $pivot = 1;
    for ^@a -> \k {
      my @r = (k+1 ..^ @a);
      my $previous-pivot = $pivot;
      if 0 == ($pivot = @a[k;k]) {
        (my \s = @r.first: { @a[$_;k] != 0 }) // return 0;
        (@a[s], @a[k]) = (@a[k], @a[s]);
        my $pivot = @a[k;k];
        $sign = -$sign;
      }
      for @r X @r -> (\i,\j) {
        ((@a[i;j] ×= $pivot) -= @a[i;k]×@a[k;j]) /= $previous-pivot;
      }
    }
    $sign × $pivot
}

sub cramers_rule(@A, @terms) {
    gather for ^@A -> \i {
        my @Ai = @A.map: { [|$_] };
        for ^@terms -> \j {
            @Ai[j;i] = @terms[j];
        }
        take det(@Ai);
    } »/» det(@A);
}

my @matrix = (
    [2, -1,  5,  1],
    [3,  2,  2, -6],
    [1,  3,  3, -1],
    [5, -2, -3,  3],
);

my @free_terms = <-3 -32 -47 49>;
my ($w, $x, $y, $z) = cramers_rule(@matrix, @free_terms);
("w = $w", "x = $x", "y = $y", "z = $z").join("\n").say;
