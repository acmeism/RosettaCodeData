role PPM {
    method P6 returns Blob {
	"P6\n{self.width} {self.height}\n255\n".encode('ascii')
	~ Blob.new: flat map { .R, .G, .B }, self.data
    }
}
my Bitmap $b = Bitmap.new( width => 125, height => 125) but PPM;
for ^$b.height X ^$b.width -> $i, $j {
    $b.pixel($i, $j) = Pixel.new: :R($i*2), :G($j*2), :B(255-$i*2);
}

$*OUT.write: $b.P6;
