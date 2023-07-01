use SVG;
use List::Util qw(max min);

use constant pi => 2 * atan2(1, 0);

# Compute the curve with a Lindemayer-system
my $koch = 'F--F--F';
$koch =~ s/F/F+F--F+F/g for 1..5;

# Draw the curve in SVG
($x, $y) = (0, 0);
$theta   = pi/3;
$r       = 2;

for (split //, $koch) {
    if (/F/) {
        push @X, sprintf "%.0f", $x;
        push @Y, sprintf "%.0f", $y;
        $x += $r * cos($theta);
        $y += $r * sin($theta);
    }
    elsif (/\+/) { $theta += pi/3; }
    elsif (/\-/) { $theta -= pi/3; }
}

$xrng =  max(@X) - min(@X);
$yrng =  max(@Y) - min(@Y);
$xt   = -min(@X)+10;
$yt   = -min(@Y)+10;
$svg = SVG->new(width=>$xrng+20, height=>$yrng+20);
$points = $svg->get_path(x=>\@X, y=>\@Y, -type=>'polyline');
$svg->rect(width=>"100%", height=>"100%", style=>{'fill'=>'black'});
$svg->polyline(%$points, style=>{'stroke'=>'orange', 'stroke-width'=>1}, transform=>"translate($xt,$yt)");

open  $fh, '>', 'koch_curve.svg';
print $fh  $svg->xmlify(-namespace=>'svg');
close $fh;
