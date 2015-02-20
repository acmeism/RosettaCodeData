use strict;
use warnings;

use constant halfpi => atan2(1, 0);

# Computing the dragon with a L-System
my $dragon = 'FX';
for (1 .. 10) {
    $dragon =~ s/X/x+yF+/g;
    $dragon =~ s/Y/-Fx-y/g;
    $dragon =~ tr/xy/XY/;
}

# Drawing the dragon in SVG
my ($x, $y) = (100, 100);
my $theta = 0;
my $r = 2;

print "<?xml version='1.0' encoding='utf-8' standalone='no'?>
<!DOCTYPE svg PUBLIC '-//W3C//DTD SVG 1.1//EN'
'http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd'>
<svg width='100%' height='100%' version='1.1'
xmlns='http://www.w3.org/2000/svg'>\n";

for (split //, $dragon) {
    if (/F/) {
	printf "<line x1='%.0f' y1='%.0f' ", $x, $y;
	printf "x2='%.0f' ", $x += $r * cos($theta);
	printf "y2='%.0f' ", $y += $r * sin($theta);
	print "style='stroke:rgb(0,0,0);stroke-width:1'/>\n";
    }
    elsif (/\+/) { $theta += halfpi; }
    elsif (/\-/) { $theta -= halfpi; }
}

print "</svg>";
