class Pixel { has Int ($.R, $.G, $.B) }
class Bitmap {
    has Int ($.width, $.height);
    has Pixel @.data;

    method pixel(
	    $i where ^$!width,
	    $j where ^$!height
	    --> Pixel
      ) is rw { @!data[$i + $j * $!width] }
}

role PPM {
    method P6 returns Blob {
	"P6\n{self.width} {self.height}\n255\n".encode('ascii')
	~ Blob.new: flat map { .R, .G, .B }, self.data
    }
}

sub load-ppm ( $ppm ) {
    my $fh    = $ppm.IO.open( :enc('ISO-8859-1') );
    my $type  = $fh.get;
    my ($width, $height) = $fh.get.split: ' ';
    my $depth = $fh.get;
    Bitmap.new( width => $width.Int, height => $height.Int,
      data => ( $fh.slurp.ords.rotor(3).map:
        { Pixel.new(R => $_[0], G => $_[1], B => $_[2]) } )
    )
}

sub color-distance (Pixel $c1, Pixel $c2) {
    sqrt( ( ($c1.R - $c2.R)² + ($c1.G - $c2.G)² + ($c1.B - $c2.B)² ) / ( 255 * sqrt(3) ) );
}

sub flood ($img, $x, $y, $c1) {
    my $c2 = $img.pixel($x, $y);
    my $max-distance = 10;
    my @queue;
    my %checked;
    check($x, $y);
    for @queue -> [$x, $y] {
        $img.pixel($x, $y) = $c1.clone;
    }

    sub check ($x, $y) {
        my $c3 = $img.pixel($x, $y);

        if color-distance($c2, $c3) < $max-distance {
            @queue.push: [$x,$y];
            @queue.elems;
            %checked{"$x,$y"} = 1;
            check($x - 1, $y) if $x > 0               and %checked{"{$x - 1},$y"}:!exists;
            check($x + 1, $y) if $x < $img.width - 1  and %checked{"{$x + 1},$y"}:!exists;
            check($x, $y - 1) if $y > 0               and %checked{"$x,{$y - 1}"}:!exists;
            check($x, $y + 1) if $y < $img.height - 1 and %checked{"$x,{$y + 1}"}:!exists;
        }
    }
}

my $infile = './Unfilled-Circle.ppm';

my Bitmap $b = load-ppm( $infile ) but PPM;

flood($b, 5,     5, Pixel.new(:255R, :0G, :0B));
flood($b, 5,   125, Pixel.new(:255R, :0G, :0B));
flood($b, 125,   5, Pixel.new(:255R, :0G, :0B));
flood($b, 125, 125, Pixel.new(:255R, :0G, :0B));
flood($b, 50,   50, Pixel.new(:0R, :0G, :255B));

my $outfile = open('./Bitmap-flood-perl6.ppm', :w, :bin);

$outfile.write: $b.P6;
