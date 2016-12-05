my @colors = map -> $r, $g, $b { Buf.new: $r, $g, $b },
		map -> $x { floor ($x/256) ** 3 * 256 },
		    (flat (0...255) Z
		     (255...0) Z
		     flat (0,2...254),(254,252...0));


my $PPM = open "munching.ppm", :w, :bin or die "Can't create munching.ppm: $!";

$PPM.print: qq:to/EOH/;
    P6
    # munching.pgm
    256 256
    255
    EOH

$PPM.write: @colors[$_] for ^256 X+^ ^256;

$PPM.close;
