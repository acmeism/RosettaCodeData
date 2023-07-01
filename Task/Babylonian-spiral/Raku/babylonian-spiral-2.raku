my @next = { :x(1), :y(1), :2hyp },;

sub next-interval (Int $int) {
     @next.append: (0..$int).map: { %( :x($int), :y($_), :hyp($int² + .²) ) };
     @next = |@next.sort: *.<hyp>;
}

my @spiral = [\»+«] lazy gather {
    my $interval = 1;
    take [0,0];
    take my @tail = 0,1;
    loop {
        my \Θ = atan2 |@tail[1,0];
        my @this = @next.shift;
        @this.push: @next.shift while @next and @next[0]<hyp> == @this[0]<hyp>;
        my @candidates = @this.map: {
            my (\i, \j) = .<x y>;
            next-interval(++$interval) if $interval == i;
            |((i,j),(-i,j),(i,-j),(-i,-j),(j,i),(-j,i),(j,-i),(-j,-i))
        }
        take @tail = |@candidates.min: { ( Θ - atan2 |.[1,0] ) % τ };
    }
}

# The task
say "The first $_ Babylonian spiral points are:\n",
@spiral[^$_].map({ sprintf '(%3d,%4d)', |$_ }).batch(10).join: "\n" given 40;

# Stretch
use SVG;

'babylonean-spiral-raku.svg'.IO.spurt: SVG.serialize(
    svg => [
        :width<100%>, :height<100%>,
        :rect[:width<100%>, :height<100%>, :style<fill:white;>],
        :polyline[ :points(flat @spiral[^10000]),
          :style("stroke:red; stroke-width:6; fill:white;"),
          :transform("scale (.05, -.05) translate (1000,-10000)")
        ],
    ],
);
