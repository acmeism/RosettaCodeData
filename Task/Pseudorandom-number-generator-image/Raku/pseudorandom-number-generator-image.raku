# 20200818 Raku programming solution

use Image::PNG::Portable;

srand 2⁶³ - 25; # greatest prime smaller than 2⁶³ and the max my system can take

my @data = < 250 500 1000 1500 >;

@data.map: {
   my $o = Image::PNG::Portable.new: :width($_), :height($_);
   for ^$_ X ^$_ -> @pixel { # about 40% slower if split to ($x,$y) or (\x,\y)
      $o.set: @pixel[0], @pixel[1], 256.rand.Int, 256.rand.Int, 256.rand.Int
   }
   $o.write: "image$_.png" or die;
}
