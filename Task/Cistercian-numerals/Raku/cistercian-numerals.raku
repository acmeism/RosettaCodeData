my @line-segments = (0, 0, 0, 100),
    (0,  0, 35,  0), (0, 35, 35, 35), (0,  0, 35, 35), (0, 35, 35,  0), ( 35,  0, 35, 35),
    (0,  0,-35,  0), (0, 35,-35, 35), (0,  0,-35, 35), (0, 35,-35,  0), (-35,  0,-35, 35),
    (0,100, 35,100), (0, 65, 35, 65), (0,100, 35, 65), (0, 65, 35,100), ( 35, 65, 35,100),
    (0,100,-35,100), (0, 65,-35, 65), (0,100,-35, 65), (0, 65,-35,100), (-35, 65,-35,100);

my @components = map {@line-segments[$_]}, |((0, 5, 10, 15).map: -> $m {
    |((0,), (1,), (2,), (3,), (4,), (1,4), (5,), (1,5), (2,5), (1,2,5)).map: {$_ »+» $m}
});

my $out = 'Cistercian-raku.svg'.IO.open(:w);

$out.say: # insert header
q|<svg  width="875" height="470" style="stroke:black;" version="1.1" xmlns="http://www.w3.org/2000/svg">
 <rect width="100%" height="100%" style="fill:white;"/>|;

my $hs = 50; # horizontal spacing
my $vs = 25; # vertical spacing

for flat ^10, 20, 300, 4000, 5555, 6789, 9394, (^10000).pick(14) -> $cistercian {

    $out.say: |@components[0].map: { # draw zero / base vertical bar
        qq|<line x1="{.[0] + $hs}" y1="{.[1] + $vs}" x2="{.[2] + $hs}" y2="{.[3] + $vs}"/>|
    };

    my @orders-of-magnitude = $cistercian.polymod(10 xx *);

    for @orders-of-magnitude.kv -> $order, $value {
        next unless $value; # skip zeros, already drew zero bar
        last if $order > 3; # truncate too large integers

        # draw the component line segments
        $out.say: join "\n", @components[$order * 10 + $value].map: {
            qq|<line x1="{.[0] + $hs}" y1="{.[1] + $vs}" x2="{.[2] + $hs}" y2="{.[3] + $vs}"/>|
        }
    }

    # insert the decimal number below
    $out.say: qq|<text x="{$hs - 5}" y="{$vs + 120}">{$cistercian}</text>|;

    if ++$ %% 10 { # next row
        $hs = -35;
        $vs += 150;
    }

    $hs += 85; # increment horizontal spacing


}
$out.say: q|</svg>|; # insert footer
