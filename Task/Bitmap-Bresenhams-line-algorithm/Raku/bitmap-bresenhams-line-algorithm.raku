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
	self.pixel($i, $j) = $p.clone;
    }
    method get-pixel ($i, $j) returns Pixel {
	self.pixel($i, $j);
    }
}

sub line(Bitmap $bitmap, $x0 is copy, $x1 is copy, $y0 is copy, $y1 is copy) {
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
        my $pix = Pixel.new(R => 100, G => 200, B => 0);
        if $steep {
            $bitmap.set-pixel($y, $x, $pix);
        } else {
            $bitmap.set-pixel($x, $y, $pix);
        }
        $error += $Δerror;
        if $error >= 0.5 {
            $y += $y-step;
            $error -= 1.0;
        }
    }
}
