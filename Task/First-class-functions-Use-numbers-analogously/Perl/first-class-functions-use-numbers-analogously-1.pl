sub multiplier {
    my ( $n1, $n2 ) = @_;
    sub {
        $n1 * $n2 * $_[0];
    };
}

my $x  = 2.0;
my $xi = 0.5;
my $y  = 4.0;
my $yi = 0.25;
my $z  = $x + $y;
my $zi = 1.0 / ( $x + $y );

my %zip;
@zip{ $x, $y, $z } = ( $xi, $yi, $zi );

while ( my ( $number, $inverse ) = each %zip ) {
    print multiplier( $number, $inverse )->(0.5), "\n";
}
