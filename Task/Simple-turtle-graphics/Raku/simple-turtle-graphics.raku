# 20250303 Raku programming solution

use Cairo;

sub house(Cairo::Context $cr, $x, $y, $size) {
   $cr.save;
   $cr.rgb(1.0, 1.0, 1.0);

   $cr.rectangle($x, $y, $size, $size);
   $cr.stroke;

   $cr.move_to($x + $size / 2, $y - $size / 2);
   $cr.line_to($x, $y);
   $cr.line_to($x + $size, $y);
   $cr.close_path;
   $cr.stroke;

   $cr.restore;
}

sub barchart(Cairo::Context $cr, @data, $x is copy, $y, $size) {
   $cr.save;
   $cr.rgb(1.0, 1.0, 1.0);

   my $maxdata = @data.max || 1;
   my $bar-width = $size / (@data.elems || 1);
   my $bar-spacing = $bar-width * 0.1;

   for @data -> $n {
      my $bar-height = ($n / $maxdata) * $size;
      $cr.rectangle($x, $y - $bar-height, $bar-width - $bar-spacing, $bar-height);
      $cr.stroke;
      $x += $bar-width;
   }

   $cr.restore;
}

sub testturtle($width = 400, $height = 600) {
   my $image = Cairo::Image.create(Cairo::FORMAT_ARGB32, $width, $height);
   my $cr = Cairo::Context.new($image);

   $cr.rgb(0.0, 0.0, 0.0);
   $cr.paint;

   $cr.line_width = 2.0;

   barchart($cr, [15, 10, 50, 35, 20], $width * 0.6, $height, $width / 3);
   house($cr, $width / 4, $height / 3, $width / 3);

   $image.write_png('turtle-raku.png');
}

testturtle();
