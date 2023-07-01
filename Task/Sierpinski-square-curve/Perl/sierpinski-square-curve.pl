use strict;
use warnings;
use SVG;
use List::Util qw(max min);
use constant pi => 2 * atan2(1, 0);

my $rule = 'XF-F+F-XF+F+XF-F+F-X';
my $S = 'F+F+XF+F+XF';
$S =~ s/X/$rule/g for 1..5;

my (@X, @Y);
my ($x, $y) = (0, 0);
my $theta   = pi/4;
my $r       = 6;

for (split //, $S) {
    if (/F/) {
        push @X, sprintf "%.0f", $x;
        push @Y, sprintf "%.0f", $y;
        $x += $r * cos($theta);
        $y += $r * sin($theta);
    }
    elsif (/\+/) { $theta += pi/2; }
    elsif (/\-/) { $theta -= pi/2; }
}

my ($xrng, $yrng) = ( max(@X) - min(@X),  max(@Y) - min(@Y));
my ($xt,   $yt)   = (-min(@X) + 10,      -min(@Y) + 10);

my $svg = SVG->new(width=>$xrng+20, height=>$yrng+20);
my $points = $svg->get_path(x=>\@X, y=>\@Y, -type=>'polyline');
$svg->rect(width=>"100%", height=>"100%", style=>{'fill'=>'black'});
$svg->polyline(%$points, style=>{'stroke'=>'orange', 'stroke-width'=>1}, transform=>"translate($xt,$yt)");

open my $fh, '>', 'sierpinski-square-curve.svg';
print $fh  $svg->xmlify(-namespace=>'svg');
close $fh;
