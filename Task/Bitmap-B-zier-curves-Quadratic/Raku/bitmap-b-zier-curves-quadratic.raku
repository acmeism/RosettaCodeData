class Pixel { has UInt ($.R, $.G, $.B) }
class Bitmap {
    has UInt ($.width, $.height);
    has Pixel @!data;

    method fill(Pixel $p) {
        @!data = $p.clone xx ($!width*$!height)
    }
    method pixel(
	  $i where ^$!width,
	  $j where ^$!height
	  --> Pixel
    ) is rw { @!data[$i + $j * $!width] }

    method set-pixel ($i, $j, Pixel $p) {
        return if $j >= $!height;
        self.pixel($i, $j) = $p.clone;
    }
    method get-pixel ($i, $j) returns Pixel {
	    self.pixel($i, $j);
    }

    method line(($x0 is copy, $y0 is copy), ($x1 is copy, $y1 is copy), $pix) {
        my $steep = abs($y1 - $y0) > abs($x1 - $x0);
        if $steep {
            ($x0, $y0) = ($y0, $x0);
            ($x1, $y1) = ($y1, $x1);
        }
        if $x0 > $x1 {
            ($x0, $x1) = ($x1, $x0);
            ($y0, $y1) = ($y1, $y0);
        }
        my $Δx = $x1 - $x0;
        my $Δy = abs($y1 - $y0);
        my $error = 0;
        my $Δerror = $Δy / $Δx;
        my $y-step = $y0 < $y1 ?? 1 !! -1;
        my $y = $y0;
        for $x0 .. $x1 -> $x {
            if $steep {
                self.set-pixel($y, $x, $pix);
            } else {
                self.set-pixel($x, $y, $pix);
            }
            $error += $Δerror;
            if $error >= 0.5 {
                $y += $y-step;
                $error -= 1.0;
            }
        }
    }

    method dot (($px, $py), $pix, $radius = 2) {
        for $px - $radius .. $px + $radius -> $x {
            for $py - $radius .. $py + $radius -> $y {
                self.set-pixel($x, $y, $pix) if ( $px - $x + ($py - $y) * i ).abs <= $radius;
            }
        }
    }

    method quadratic ( ($x1, $y1), ($x2, $y2), ($x3, $y3), $pix, $segments = 30 ) {
        my @line-segments = map -> $t {
            my \a = (1-$t)²;
            my \b = $t * (1-$t) * 2;
            my \c = $t²;
            (a*$x1 + b*$x2 + c*$x3).round(1),(a*$y1 + b*$y2 + c*$y3).round(1)
        }, (0, 1/$segments, 2/$segments ... 1);
        for @line-segments.rotor(2=>-1) -> ($p1, $p2) { self.line( $p1, $p2, $pix) };
    }

    method data { @!data }
}

role PPM {
    method P6 returns Blob {
	"P6\n{self.width} {self.height}\n255\n".encode('ascii')
	~ Blob.new: flat map { .R, .G, .B }, self.data
    }
}

sub color( $r, $g, $b) { Pixel.new(R => $r, G => $g, B => $b) }

my Bitmap $b = Bitmap.new( width => 600, height => 400) but PPM;

$b.fill( color(2,2,2) );

my @points = (65,25), (85,380), (570,15);

my %seen;
my $c = 0;
for @points.permutations -> @this {
    %seen{@this.reverse.join.Str}++;
    next if %seen{@this.join.Str};
    $b.quadratic( |@this, color(255-$c,127,$c+=80) );
}

@points.map: { $b.dot( $_, color(255,0,0), 3 )}

$*OUT.write: $b.P6;
