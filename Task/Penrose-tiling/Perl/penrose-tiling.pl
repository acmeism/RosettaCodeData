use constant pi => 2 * atan2(1, 0);

# Generated with a P3 tile set using a Lindenmayer system.
%rules = (
    A => '',
    M => 'OA++PA----NA[-OA----MA]++',
    N => '+OA--PA[---MA--NA]+',
    O => '-MA++NA[+++OA++PA]-',
    P => '--OA++++MA[+PA++++NA]--NA'
);
$penrose = '[N]++[N]++[N]++[N]++[N]';
$penrose =~ s/([AMNOP])/$rules{$1}/eg for 1..4;

# Draw the curve in SVG
($x, $y) = (160, 160);
$theta   = pi/5;
$r       = 20;

for (split //, $penrose) {
    if (/A/) {
        $line  = sprintf "<line x1='%.1f' y1='%.1f' ", $x, $y;
        $line .= sprintf "x2='%.1f' ", $x += $r * cos($theta);
        $line .= sprintf "y2='%.1f' ", $y += $r * sin($theta);
        $line .= "style='stroke:rgb(255,165,0)'/>\n";
        $SVG{$line} = 1;
    } elsif (/\+/) { $theta += pi/5
    } elsif (/\-/) { $theta -= pi/5
    } elsif (/\[/) { push @stack, [$x, $y, $theta]
    } elsif (/\]/) { ($x, $y, $theta) = @{pop @stack} }
}
$svg .= $_ for keys %SVG;
open  $fh, '>', 'penrose_tiling.svg';
print $fh  qq{<svg xmlns="http://www.w3.org/2000/svg" height="350" width="350"> <rect height="100%" width="100%" style="fill:black" />\n$svg</svg>};
close $fh;
