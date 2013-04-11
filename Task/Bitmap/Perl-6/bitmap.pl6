class Pixel {
	has Int $.R;
	has Int $.G;
	has Int $.B;
}

class Bitmap {
	has Pixel @.data;
	has Int $.width;
	has Int $.height;

	method fill(Pixel $p) {
		for ^$.width X ^$.height -> $i, $j {
			@.data[$i][$j] = $p.clone;
		}
	}

	method set-pixel ( $i, $j, Pixel $value) {
		fail unless 0 <= $i <= $.width && 0 <= $j <= $.height;
		@.data[$i][$j] = $value;
	}

	method get-pixel ($i, $j) {
		fail unless 0 <= $i <= $.width && 0 <= $j <= $.height;
		@.data[$i][$j];
	}
}

# Usage:

my Bitmap $b = Bitmap.new( width => 10, height => 10);

$b.fill( Pixel.new( R => 0, G => 0, B => 200) );

$b.set-pixel( 7, 5, Pixel.new( R => 100, G => 200, B => 0) );

say $b.perl;
