constant scoring = 0, 1, 3;
my @histo = [0 xx 10] xx 4;

for [X] ^3 xx 6 -> @results {
    my @s;

    for @results Z (^4).combinations(2) -> ($r, @g) {
        @s[@g[0]] += scoring[$r];
        @s[@g[1]] += scoring[2 - $r];
    }

    for @histo Z @s.sort -> (@h, $v) {
        ++@h[$v];
    }
}

say .fmt('%3d',' ') for @histo.reverse;
