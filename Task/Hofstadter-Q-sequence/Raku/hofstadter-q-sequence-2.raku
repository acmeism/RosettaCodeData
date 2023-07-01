my @Q = 1, 1, -> $a, $b {
    (state $n = 1)++;
    @Q[$n - $a] + @Q[$n - $b]
} ... *;

# Testing:

say "first ten: ", @Q[^10];
say "1000th: ", @Q[999];
say "In the first 100_000 terms, ",
   [+](@Q[1..100000] Z< @Q[0..99999]),
   " terms are less than their preceding terms";
