sub levenshtein_distance ( Str $s, Str $t --> Int ) {
    my @s = *, $s.comb;
    my @t = *, $t.comb;

    my @d;
    @d[$_][ 0] = $_ for ^@s.end;
    @d[ 0][$_] = $_ for ^@t.end;

    for 1..@s.end X 1..@t.end -> $i, $j {
        @d[$i][$j] = @s[$i] eq @t[$j]
            ??   @d[$i-1][$j-1]    # No operation required when eq
            !! ( @d[$i-1][$j  ],   # Deletion
                 @d[$i  ][$j-1],   # Insertion
                 @d[$i-1][$j-1],   # Substitution
               ).min + 1;
    }

    return @d[*-1][*-1];
}

my @a = [<kitten sitting>], [<saturday sunday>], [<rosettacode raisethysword>];

for @a -> [$s, $t] {
    say "levenshtein_distance('$s', '$t') == ", levenshtein_distance($s, $t);
}
