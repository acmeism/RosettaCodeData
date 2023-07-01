use MONKEY-TYPING;

class Pixel { has UInt ($.R, $.G, $.B) }
class Bitmap {
    has UInt ($.width, $.height);
    has Pixel @!data;

    method fill(Pixel \p) {
        @!data = p xx ($!width × $!height)
    }

    method pixel( \i where ^$!width, \j where ^$!height --> Pixel) is rw {
        @!data[i × $!width + j]
    }

    method set-pixel (\i, \j, Pixel \p) {
        self.pixel(i, j) = p;
    }

    method get-pixel (\i, \j) returns Pixel {
        self.pixel(i, j);
    }
}

augment class Pixel  { method Str { "$.R $.G $.B" } }
augment class Bitmap {
    method P3 {
        join "\n", «P3 "$.width $.height" 255»,
        do for ^($.width × $.height) { join ' ', @!data[$_] }
    }

    method raster-circle ( \x0, \y0, \r, Pixel \value ) {
        my $ddF_x   =  0;
        my $ddF_y   = -2 × r;
        my $f       =  1 - r;
        my ($x, $y) =  0,  r;
        for flat (0 X 1,-1),(1,-1 X 0) -> \i, \j {
            self.set-pixel(x0 + i×r, y0 + j×r, value)
        }

        while $x < $y {
            ($y--; $f +=     ($ddF_y += 2)) if $f ≥ 0;
             $x++; $f += 1 + ($ddF_x += 2);
            for flat (1,-1) X (1,-1) -> \i, \j {
                self.set-pixel(x0 + i×$x, y0 + j×$y, value);
                self.set-pixel(x0 + i×$y, y0 + j×$x, value);
            }
        }
    }
}

my Bitmap $b = Bitmap.new( width => 32, height => 32);
$b.fill( Pixel.new( R => 0, G => 0, B => 0) );
$b.raster-circle(16, 16, 15, Pixel.new(R=>0, G=>0, B=>100));
say $b.P3;
