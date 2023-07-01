sub kronecker-product ( @a, @b ) { (@a X @b).map: { (.[0].list X* .[1].list).Array } }

sub kronecker-fractal ( @pattern, $order = 4 ) {
    my @kronecker = @pattern;
    @kronecker = kronecker-product(@kronecker, @pattern) for ^$order;
    @kronecker
}

use Image::PNG::Portable;

#Task requirements
my @vicsek = ( [0, 1, 0], [1, 1, 1], [0, 1, 0] );
my @carpet = ( [1, 1, 1], [1, 0, 1], [1, 1, 1] );
my @six    = ( [0,1,1,1,0], [1,0,0,0,1], [1,0,0,0,0], [1,1,1,1,0], [1,0,0,0,1], [1,0,0,0,1], [0,1,1,1,0] );

for  'vicsek', @vicsek, 4,
     'carpet', @carpet, 4,
     'six',    @six,    3
  -> $name,    @shape,  $order {
    my @img = kronecker-fractal( @shape, $order );
    my $png = Image::PNG::Portable.new: :width(@img[0].elems), :height(@img.elems);
    (^@img[0]).race(:12batch).map: -> $x {
        for ^@img -> $y {
            $png.set: $x, $y, |( @img[$y;$x] ?? <255 255 32> !! <16 16 16> );
        }
    }
    $png.write: "kronecker-{$name}-perl6.png";
}
