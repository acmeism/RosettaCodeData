use SVG;
use List::Util qw(max min);

use constant pi => 2 * atan2(1, 0);

# Compute the curve with a Lindemayer-system
%rules = (
    A => '-BF+AFA+FB-',
    B => '+AF-BFB-FA+'
);
$hilbert = 'A';
$hilbert =~ s/([AB])/$rules{$1}/eg for 1..6;

# Draw the curve in SVG
($x, $y) = (0, 0);
$theta   = pi/2;
$r       = 5;

for (split //, $hilbert) {
    if (/F/) {
        push @X, sprintf "%.0f", $x;
        push @Y, sprintf "%.0f", $y;
        $x += $r * cos($theta);
        $y += $r * sin($theta);
    }
    elsif (/\+/) { $theta += pi/2; }
    elsif (/\-/) { $theta -= pi/2; }
}

$max =  max(@X,@Y);
$xt  = -min(@X)+10;
$yt  = -min(@Y)+10;
$svg = SVG->new(width=>$max+20, height=>$max+20);
$points = $svg->get_path(x=>\@X, y=>\@Y, -type=>'polyline');
$svg->rect(width=>"100%", height=>"100%", style=>{'fill'=>'black'});
$svg->polyline(%$points, style=>{'stroke'=>'orange', 'stroke-width'=>1}, transform=>"translate($xt,$yt)");

open  $fh, '>', 'hilbert_curve.svg';
print $fh  $svg->xmlify(-namespace=>'svg');
close $fh;
