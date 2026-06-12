sub gauss ( @m is copy ) {
    for @m.keys -> \i {
        my \k = max |(i .. @m.end), :by({ @m[$_][i].abs });

        @m[i, k] .= reverse if \k != i;

        .[i ^.. *] »/=» .[i] given @m[i];

        for i ^.. @m.end -> \j {
            @m[j][i ^.. *] »-=« ( @m[j][i] «*« @m[i][i ^.. *] );
        }
    }
    for @m.keys.reverse -> \i {
        @m[^i]».[*-1] »-=« ( @m[^i]».[i] »*» @m[i][*-1] );
    }
    return @m».[*-1];
}
sub network ( Int \n, Int \k0, Int \k1, Str \grid ) {
    my @m = [0 xx n+1] xx n;

    for grid.split('|') -> \resistor {
        my ( \a, \b, \r_inv ) = resistor.split(/\s+/, :skip-empty);
        my \r = 1 / r_inv;

        @m[a][a] += r;
        @m[b][b] += r;
        @m[a][b] -= r if a > 0;
        @m[b][a] -= r if b > 0;
    }
    @m[k0][k0]  = 1;
    @m[k1][*-1] = 1;

    return gauss(@m)[k1];
}
use Test;
my @tests =
    (   10,   7, 0,     1, '0 2 6|2 3 4|3 4 10|4 5 2|5 6 8|6 1 4|3 5 6|3 6 6|3 1 8|2 1 8' ),
    (  3/2, 3*3, 0, 3*3-1, '0 1 1|1 2 1|3 4 1|4 5 1|6 7 1|7 8 1|0 3 1|3 6 1|1 4 1|4 7 1|2 5 1|5 8 1' ),
    ( 13/7, 4*4, 0, 4*4-1, '0 1 1|1 2 1|2 3 1|4 5 1|5 6 1|6 7 1|8 9 1|9 10 1|10 11 1|12 13 1|13 14 1|14 15 1|0 4 1|4 8 1|8 12 1|1 5 1|5 9 1|9 13 1|2 6 1|6 10 1|10 14 1|3 7 1|7 11 1|11 15 1' ),
    (  180,   4, 0,     3, '0 1 150|0 2 50|1 3 300|2 3 250' ),
;
plan +@tests;
is .[0], network( |.[1..4] ), .[4].substr(0,10)~'…' for @tests;
