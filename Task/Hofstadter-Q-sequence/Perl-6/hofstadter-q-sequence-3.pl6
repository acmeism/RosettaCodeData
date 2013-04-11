constant @Q = 1, 1, -> $a, $b {
    (state $n = 1)++;
    @Q[$n - $a] + @Q[$n - $b]
} ... *;
