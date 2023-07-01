use Modern::Perl;
use List::Util qw{ min max sum };

sub water_collected {
    my @t = map { { TOWER => $_, LEFT => 0, RIGHT => 0, LEVEL => 0 } } @_;

    my ( $l, $r ) = ( 0, 0 );
    $_->{LEFT}  = ( $l = max( $l, $_->{TOWER} ) ) for @t;
    $_->{RIGHT} = ( $r = max( $r, $_->{TOWER} ) ) for reverse @t;
    $_->{LEVEL} = min( $_->{LEFT}, $_->{RIGHT} )  for @t;

    return sum map { $_->{LEVEL} > 0 ? $_->{LEVEL} - $_->{TOWER} : 0 } @t;
}

say join ' ', map { water_collected( @{$_} ) } (
    [ 1, 5,  3, 7, 2 ],
    [ 5, 3,  7, 2, 6, 4, 5, 9, 1, 2 ],
    [ 2, 6,  3, 5, 2, 8, 1, 4, 2, 2, 5, 3, 5, 7, 4, 1 ],
    [ 5, 5,  5, 5 ],
    [ 5, 6,  7, 8 ],
    [ 8, 7,  7, 6 ],
    [ 6, 7, 10, 7, 6 ],
);
