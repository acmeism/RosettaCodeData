class Pixel { has Int ($.R, $.G, $.B) }
class Bitmap {
    has Int ($.width, $.height);
    has Pixel @.data;

    method fill(Pixel $p) {
	for ^$!width X ^$!height -> $i, $j {
	    self.pixel($i, $j) = $p.clone;
	}
    }
    method pixel(
	$i where ^self.width,
	$j where ^self.height
	--> Pixel
    ) is rw { @!data[$i*$!height + $j] }

    method set-pixel ($i, $j, Pixel $p) {
	self.pixel($i, $j) = $p.clone;
    }
    method get-pixel ($i, $j) returns Pixel {
	self.pixel($i, $j);
    }
}

my Bitmap $b = Bitmap.new( width => 10, height => 10);

$b.fill( Pixel.new( R => 0, G => 0, B => 200) );

$b.set-pixel( 7, 5, Pixel.new( R => 100, G => 200, B => 0) );

say $b.perl;
