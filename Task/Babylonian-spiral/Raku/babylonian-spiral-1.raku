sub babylonianSpiral (\nsteps) {
    my @squareCache = (0..nsteps).hyper.map: *²;
    my @dxys = [0, 0], [0, 1];
    my $dsq  = 1;

    for ^(nsteps-2) {
        my \Θ = atan2 |@dxys[*-1][1,0];
        my @candidates;

        until @candidates.elems {
            $dsq++;
            for @squareCache.kv -> \i, \a {
                last if a > $dsq/2;
                for reverse 0 .. $dsq.sqrt.ceiling -> \j {
                    last if $dsq > (a + my \b = @squareCache[j]);
                    next if $dsq != a + b;
                    @candidates.append: [i, j], [-i, j], [i, -j], [-i, -j],
                                        [j, i], [-j, i], [j, -i], [-j, -i]
                }
            }
        }
        @dxys.push: @candidates.min: { ( Θ - atan2 |.[1,0] ) % τ };
    }

    [\»+«] @dxys
}

# The task
say "The first $_ Babylonian spiral points are:\n",
(babylonianSpiral($_).map: { sprintf '(%3d,%4d)', @$_ }).batch(10).join("\n") given 40;

# Stretch
use SVG;

'babylonean-spiral-raku.svg'.IO.spurt: SVG.serialize(
    svg => [
        :width<100%>, :height<100%>,
        :rect[:width<100%>, :height<100%>, :style<fill:white;>],
        :polyline[ :points(flat babylonianSpiral(10000)),
          :style("stroke:red; stroke-width:6; fill:white;"),
          :transform("scale (.05, -.05) translate (1000,-10000)")
        ],
    ],
);
