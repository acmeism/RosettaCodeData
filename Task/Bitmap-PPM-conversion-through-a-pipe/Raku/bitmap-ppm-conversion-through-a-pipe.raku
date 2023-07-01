# Reference:
# https://rosettacode.org/wiki/Bitmap/Write_a_PPM_file#Raku

use v6;

class Pixel { has uint8 ($.R, $.G, $.B) }
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
      ) is rw { @!data[$i*$!height + $j] }

    method data { @!data }
}

role PPM {
    method P6 returns Blob {
        "P6\n{self.width} {self.height}\n255\n".encode('ascii')
        ~ Blob.new: flat map { .R, .G, .B }, self.data
    }
}

my Bitmap $b = Bitmap.new(width => 125, height => 125) but PPM;
for flat ^$b.height X ^$b.width -> $i, $j {
    $b.pixel($i, $j) = Pixel.new: :R($i*2), :G($j*2), :B(255-$i*2);
}

my $proc = run '/usr/bin/convert','-','output_piped.jpg', :in;
$proc.in.write: $b.P6;
$proc.in.close;
