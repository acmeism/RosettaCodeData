use Imager;
use Math::Cartesian::Product;

sub kronecker_product {
    our @a; local *a = shift;
    our @b; local *b = shift;
    my @c;
    cartesian {
        my @cc;
        cartesian {
            push @cc, $_[0] * $_[1];
        } [@{$_[0]}], [@{$_[1]}];
        push @c, [@cc];
    } [@a], [@b];
    @c
}

sub kronecker_fractal {
    my($order, @pattern) = @_;
    my @kronecker = @pattern;
    @kronecker = kronecker_product(\@kronecker, \@pattern) for 0..$order-1;
    @kronecker
}

@vicsek = ( [0, 1, 0], [1, 1, 1], [0, 1, 0] );
@carpet = ( [1, 1, 1], [1, 0, 1], [1, 1, 1] );
@six    = ( [0,1,1,1,0], [1,0,0,0,1], [1,0,0,0,0], [1,1,1,1,0], [1,0,0,0,1], [1,0,0,0,1], [0,1,1,1,0] );

for (['vicsek', \@vicsek, 4],
     ['carpet', \@carpet, 4],
     ['six',    \@six,    3]) {
    ($name, $shape, $order) = @$_;
    @img = kronecker_fractal( $order, @$shape );
    $png = Imager->new(xsize => 1+@{$img[0]}, ysize => 1+@img);
    cartesian {
        $png->setpixel(x => $_[0], y => $_[1], color => $img[$_[1]][$_[0]] ? [255, 255, 32] : [16, 16, 16]);
    } [0..@{$img[0]}-1], [0..$#img];
    $png->write(file => "run/kronecker-$name-perl6.png");
}
