# the following are utilities to use the same Fortran data...
sub point
{
    [shift, shift];
}
sub create_polygon
{
    my ($pts, $sides) = @_;
    my @poly;
    for(my $i = 0; $i < $#$sides; $i += 2) {
	push @poly, [ $pts->[$sides->[$i]-1], $pts->[$sides->[$i+1]-1] ];
    }
    \@poly;
}

my @pts = ( point(0,0), point(10,0), point(10,10), point(0,10),
	    point(2.5,2.5), point(7.5,2.5), point(7.5,7.5), point(2.5,7.5),
	    point(0,5), point(10,5),
	    point(3,0), point(7,0), point(7,10), point(3,10) );

my %pgs = (
    squared => create_polygon(\@pts, [ 1,2, 2,3, 3,4, 4,1 ] ),
    squaredhole => create_polygon(\@pts, [ 1,2, 2,3, 3,4, 4,1, 5,6, 6,7, 7,8, 8,5 ] ),
    strange => create_polygon(\@pts, [ 1,5, 5,4, 4,8, 8,7, 7,3, 3,2, 2,5 ] ),
    exagon => create_polygon(\@pts, [ 11,12, 12,10, 10,13, 13,14, 14,9, 9,11 ]) ,
);

my @p = ( point(5,5), point(5, 8), point(-10, 5), point(0,5), point(10,5), &
	  point(8,5), point(10,10) );

foreach my $pol ( sort keys %pgs ) {
    no strict 'refs';
    print "$pol\n";
    my $rp = $pgs{$pol};
    foreach my $tp ( @p ) {
	print "\t($tp->[0],$tp->[1]) " .
           ( point_in_polygon($tp, $rp) ? "INSIDE" : "OUTSIDE" ) . "\n";
    }
}
