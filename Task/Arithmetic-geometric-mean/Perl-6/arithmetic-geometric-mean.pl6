sub agm ($a, $g) {
    sub iter ($old) {
        my $new := [ 0.5 * [+](@$old), sqrt [*](@$old) ];
        last if $new ~~ $old;
        $new;
    }

    ([$a,$g], &iter ... 0)[*-1][0];
}

say agm 1, 1/sqrt 2;
