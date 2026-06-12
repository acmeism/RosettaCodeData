# 20250129 Raku programming solution

use Cairo;

constant HR = 1.324718;  # The Harriss Ratio, aka Ian Stewart's "plastic number"

sub harriss($ctx, $x, $y, $angle, $len, $iteration, $linew, $radius is copy = 0.0, $cntrx is copy = 0.0, $cntry is copy = 0.0) {
   return if $iteration < 1;

   my $startangle = $angle + 45;
   my $endangle = $startangle + 90;

   # Calculate end point of lines
   my $xend = $x + $len * cos($angle * pi / 180);
   my $yend = $y + $len * sin($angle * pi / 180);

   $radius = $len / sqrt(2);
   my $heading = $yend < $y ?? "SN" !! $xend < $x ?? "EW" !! $yend > $y ?? "NS" !! $xend > $x ?? "WE" !! "DIE";

   given $heading {
      when "SN" { $cntrx = $x - $len / 2;
                  $cntry = $y - $len / 2;
                  $ctx.rgb(1, 1, 0);      }
      when "EW" { $cntrx = $x - $len / 2;
                  $cntry = $y + $len / 2;
                  $ctx.rgb(1, 0, 0);      }
      when "NS" { $cntrx = $x + $len / 2;
                  $cntry = $y + $len / 2;
                  $ctx.rgb(0, 0, 1);      }
      when "WE" { $cntrx = $x + $len / 2;
                  $cntry = $y - $len / 2;
                  $ctx.rgb(0, 0, 0);      }
      default   { die }
   }

   $ctx.line_width = $linew;
   $ctx.arc($cntrx, $cntry, $radius, $startangle * pi / 180, $endangle * pi / 180);
   $ctx.stroke;

   harriss($ctx, $xend, $yend, $angle - 90, $len / HR, $iteration - 1, $linew, $radius, $cntrx, $cntry);
}

given Cairo::Image.create(Cairo::FORMAT_ARGB32, 1400, 1000) {
   given Cairo::Context.new($_) {
      .rgb(0.827, 0.827, 0.827);  # light gray background
      .paint;
      .rgb(0, 0, 0);
      .line_width = 1.0;

      my ($startx, $starty, $init_len) = 750, 740, 525 / HR / HR;

      # Reverse Order Hides Joints
      harriss($_, $startx - ($init_len / HR + $init_len / HR**3), $starty - $init_len / HR**7, 180, $init_len / HR**6, 2, 6.0);
      harriss($_, $startx - ($init_len / HR + $init_len / HR**3), $starty - ($init_len + $init_len / HR**2), 270, $init_len / HR**5, 3, 6.0);
      harriss($_, $startx + $init_len / HR**4, $starty - ($init_len + $init_len / HR**2), 270, $init_len / HR**5, 3, 6.0);
      harriss($_, $startx + $init_len / HR, $starty - ($init_len + $init_len / HR**2), 0, $init_len / HR**4, 4, 6.0);
      harriss($_, $startx - $init_len / HR**4, $starty - $init_len / HR, 0, $init_len / HR**5, 2, 10.0);
      harriss($_, $startx - $init_len / HR**4, $starty - $init_len / HR**3, -270, $init_len / HR**4, 3, 12.0);
      harriss($_, $startx - $init_len / HR, $starty - $init_len / HR**3, 180, $init_len / HR**3, 4, 12.0);
      harriss($_, $startx - $init_len / HR, $starty - $init_len, 270, $init_len / HR**2, 5, 14.0);
      harriss($_, $startx, $starty - $init_len, 0, $init_len / HR, 6, 14.0);
      harriss($_, $startx, $starty, -90, $init_len, 7, 18.0);
   }
   .write_png("harriss-spirals-raku.png");
}
