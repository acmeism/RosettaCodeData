use strict;
use warnings;

my $svg = <<'EOD';
<svg xmlns="http://www.w3.org/2000/svg"
     xmlns:svg="http://www.w3.org/2000/svg"
     xmlns:xlink="http://www.w3.org/1999/xlink" width="1200" height="825">
     <rect width="100%" height="100%" fill="#d3d004" />
     <defs>
        <g id="block">
            <polygon points="-25,-25,-25,25,25,25" fill="white" />
            <polygon points="25,25,25,-25,-25,-25" fill="black" />
            <rect x="-20" y="-20" width="40" height="40" fill="#3250ff" />
        </g>
     </defs>
EOD

for my $X (1..15) {
   for my $Y (1..10) {
    my $r = int(($X + $Y) / 2) % 4 * 90;
    my $x = $X * 75;
    my $y = $Y * 75;
    my $a = $r > 0 ? "rotate($r,$x,$y) " : '';
    $svg .= qq{<use xlink:href="#block" transform="$a translate($x,$y)" />\n}
  }
}
$svg .= '</svg>';

open my $fh, '>', 'peripheral-drift.svg';
print $fh $svg;
close $fh;
