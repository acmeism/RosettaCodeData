class Pixel { has UInt ($.R, $.G, $.B) }
class Bitmap {
    has UInt ($.width, $.height);
    has Pixel @.data;
}

role PBM {
    has @.BM;
    method P4 returns Blob {
	"P4\n{self.width} {self.height}\n".encode('ascii')
	~ Blob.new: self.BM
    }
}

sub getline ( $fh ) {
    my $line = '#'; # skip comments when reading image file
    $line = $fh.get while $line.substr(0,1) eq '#';
    $line;
}

sub load-ppm ( $ppm ) {
    my $fh    = $ppm.IO.open( :enc('ISO-8859-1') );
    my $type  = $fh.&getline;
    my ($width, $height) = $fh.&getline.split: ' ';
    my $depth = $fh.&getline;
    Bitmap.new( width => $width.Int, height => $height.Int,
      data => ( $fh.slurp.ords.rotor(3).map:
        { Pixel.new(R => $_[0], G => $_[1], B => $_[2]) } )
    )
}

sub grayscale ( Bitmap $bmp ) {
    map { (.R*0.2126 + .G*0.7152 + .B*0.0722).round(1) min 255 }, $bmp.data;
}

sub histogram ( Bitmap $bmp ) {
    my @gray = grayscale($bmp);
    my $threshold = @gray.sum / @gray;
    for @gray.rotor($bmp.width) {
        my @row = $_.list;
        @row.push(0) while @row % 8;
        $bmp.BM.append: @row.rotor(8).map: { :2(($_ X< $threshold)».Numeric.join) }
    }
}

my $filename = './Lenna.ppm';

my Bitmap $b = load-ppm( $filename ) but PBM;

histogram($b);

'./Lenna-bw.pbm'.IO.open(:bin, :w).write: $b.P4;
