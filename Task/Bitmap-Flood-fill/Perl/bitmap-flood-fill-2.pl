use strict;
use Image::Imlib2;

sub colordistance
{
    my ( $c1, $c2 ) = @_;

    my ( $r1, $g1, $b1 ) = @$c1;
    my ( $r2, $g2, $b2 ) = @$c2;
    return sqrt(( ($r1-$r2)**2 + ($g1-$g2)**2 + ($b1-$b2)**2 ))/(255.0*sqrt(3.0));
}

sub floodfill
{
    my ( $img, $x, $y, $r, $g, $b ) = @_;
    my $distparameter = 0.2;

    my %visited = ();
    my @queue = ();

    my @tcol = ( $r, $g, $b );
    my @col = $img->query_pixel($x, $y);
    if ( colordistance(\@tcol, \@col) > $distparameter ) { return; }
    push @queue, [$x, $y];
    while ( @queue ) {
	my $pointref = shift(@queue);
	( $x, $y ) = @$pointref;
	if ( ($x < 0) || ($y < 0) || ( $x >= $img->width ) || ( $y >= $img->height ) ) { next; }
	if ( ! exists($visited{"$x,$y"}) ) {
	    @col = $img->query_pixel($x, $y);
	    if ( colordistance(\@tcol, \@col) <= $distparameter ) {
		$img->draw_point($x, $y);
		$visited{"$x,$y"} = 1;
		push @queue, [$x+1, $y];
		push @queue, [$x-1, $y];
		push @queue, [$x, $y+1];
		push @queue, [$x, $y-1];
	    }
	}
    }
}

# usage example
my $img = Image::Imlib2->load("Unfilledcirc.jpg");
$img->set_color(0,255,0,255);
floodfill($img, 100,100, 0, 0, 0);
$img->save("filledcirc1.jpg");
exit 0;
