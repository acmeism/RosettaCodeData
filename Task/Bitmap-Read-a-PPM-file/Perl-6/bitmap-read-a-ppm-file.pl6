class Pixel { has UInt ($.R, $.G, $.B) }
class Bitmap {
    has UInt ($.width, $.height);
    has Pixel @.data;
}

role PGM {
    has @.GS;
    method P5 returns Blob {
	"P5\n{self.width} {self.height}\n255\n".encode('ascii')
	~ Blob.new: self.GS
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

sub grayscale ( Bitmap $bmp ) {
    $bmp.GS = map { (.R*0.2126 + .G*0.7152 + .B*0.0722).round(1) min 255 }, $bmp.data;
}

my $filename = './camelia.ppm';

my Bitmap $b = load-ppm( $filename ) but PGM;

grayscale($b);

'./camelia-gs.pgm'.IO.open(:bin, :w).write: $b.P5;
