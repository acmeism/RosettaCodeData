use SVG;

constant $dim = 200;
constant $sides = 5;

my @vertices = map { 0.9 * $dim * cis($_ * τ / $sides) }, ^$sides;

my @points   = map |*.reals.fmt("%0.3f"),
  flat @vertices[0, 2 ... *], @vertices[1, 3 ... *], @vertices[0];

say SVG.serialize(
    svg => [
        :width($dim*2), :height($dim*2),
        :rect[:width<100%>, :height<100%>, :style<fill:bisque;>],
        :polyline[ :points(@points.join: ','),
          :style("stroke:blue; stroke-width:3; fill:seashell;"),
          :transform("translate($dim,$dim) rotate(-90)")
        ],
    ],
);
