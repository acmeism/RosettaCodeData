use SVG;

my @blocks = (1..15 X 1..10).map: -> ($X, $Y) {
    my $x = $X * 75;
    my $y = $Y * 75;
    my $a = (my $r = ($X + $Y) div 2 % 4 * 90) > 0 ?? "rotate($r,$x,$y) " !! '';
    :use['xlink:href'=>'#block', 'transform'=>"{$a}translate($x,$y)"]
}

'peripheral-drift-raku.svg'.IO.spurt: SVG.serialize(
    svg => [
        :1200width, :825height,
        :rect[:width<100%>, :height<100%>, :fill<#d3d004>],
        :defs[
            :g[
                :id<block>,
                :polygon[:points<-25,-25,-25,25,25,25>, :fill<white>],
                :polygon[:points<25,25,25,-25,-25,-25>, :fill<black>],
                :rect[:x<-20>, :y<-20>, :width<40>, :height<40>, :fill<#3250ff>]
            ]
        ],
        |@blocks,
    ]
)
